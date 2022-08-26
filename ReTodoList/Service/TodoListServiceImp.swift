//
//  TodoListServiceImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation

final class TodoListServiceImp: TodoListService {

    private let networking: TodoListNetworking

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    private var mergeAttempts = 0
    private static let maxMergeAttempts = 6

    init(networking: TodoListNetworking) {
        self.networking = networking
    }

    func getItems(_ completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        networking.fetchTodoList { result in
            switch result {
            case .success(let dtos):
                TodoListServiceImp.successWith(dtos, completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {
        networking.createTodoItem(TodoItemDTO(item)) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {
        networking.updateTodoItem(TodoItemDTO(item)) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {
        networking.deleteTodoItem(item.id) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func mergeWithRemote(_ deleted: [String], _ other: [TodoItem],
                         _ completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let requestData = MergeTodoListRequestData(deleted: deleted, other: other.map { TodoItemDTO($0) })
        networking.mergeTodoList(requestData) { [weak self] result in
            switch result {
            case .success(let dtos):
                self?.currentDelay = TodoListServiceImp.minDelay
                self?.mergeAttempts = 0
                TodoListServiceImp.successWith(dtos, completion)
            case .failure(let error):
                if (self?.mergeAttempts ?? 0) > TodoListServiceImp.maxMergeAttempts {
                    self?.mergeAttempts = 0
                    return completion(.failure(error))
                }

                self?.retryMergeRequestAfter(
                    delay: self?.nextDelay ?? TodoListServiceImp.minDelay, deleted, other, completion
                )
                self?.currentDelay = self?.nextDelay ?? TodoListServiceImp.minDelay
            }
        }
    }

    private static func successWith(_ dtos: [TodoItemDTO],
                                    _ completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        var items = dtos.map { TodoItem($0) }

        items.sortByCreateAt()
        completion(.success(items))
    }

    private var nextDelay: Double {
        let delay = min(currentDelay * TodoListServiceImp.factor, TodoListServiceImp.maxDelay)
        let next = delay + delay * TodoListServiceImp.jitter * Double.random(in: -1.0...1.0)

        return next
    }

    private func retryMergeRequestAfter(delay: Double,
                                        _ deleted: [String],
                                        _ other: [TodoItem],
                                        _ completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        mergeAttempts += 1
        let seconds: Int = Int(delay)
        let milliseconds: Int = Int((delay - Double(seconds)) * Double(1000))
        let deadlineTime = DispatchTime.now() + .seconds(seconds) + .milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            self?.mergeWithRemote(deleted, other, completion)
        }
    }
}
