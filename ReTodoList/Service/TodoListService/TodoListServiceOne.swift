//
//  TodoItemCRUDModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 30.06.2021.
//

import Foundation
import ReSwift

/// Общая логика отправки и обработки сетевых запросов создания, обновления и удаления todo item'a.
class TodoListServiceOne: TodoListService {

    private let isRemotingEnabled: Bool
    private let cache: TodoListCache
    private let deadItemsCache: DeadItemsCache
    private let networking: NetworkingService
    private let dispatch: (Action) -> Void

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    init(isRemotingEnabled: Bool,
         cache: TodoListCache,
         deadItemsCache: DeadItemsCache,
         networking: NetworkingService,
         dispatch: @escaping (Action) -> Void) {
        self.isRemotingEnabled = isRemotingEnabled
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.networking = networking
        self.dispatch = dispatch
    }

    var cachedItems: [TodoItem] {
        cache.items
    }

    func fetchRemoteTodoList(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        if cache.isDirty {
            return mergeWithRemote(completion)
        }

        dispatch(GetRemoteItemsStartAction())
        networking.fetchTodoList { [weak self] result in
            do {
                let fetchedItems = try result.get().map { TodoItem($0) }
                let mergedItems = self?.cachedItems.mergeWith(fetchedItems) ?? []

                self?.dispatch(GetRemoteItemsSuccessAction(items: mergedItems))
                self?.cache.replaceWith(mergedItems) { error in
                    completion(error)
                }
            } catch {
                self?.dispatch(GetRemoteItemsErrorAction(error: error))
                completion(error)
            }
        }
    }

    func createRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return cache.insert(todoItem.update(isDirty: true)) { _ in
                completion(TodoListServiceError.remotingDisabled)
            }
        }

        if cache.isDirty {
            return cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }
        }

        cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.dispatch(CreateRemoteItemStartAction(item: todoItem))
            self?.networking.createTodoItem(TodoItemDTO(todoItem)) { [weak self] result in
                do {
                    _ = try result.get()

                    self?.dispatch(CreateRemoteItemSuccessAction(item: todoItem))
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.dispatch(CreateRemoteItemErrorAction(item: todoItem, error: error))
                    self?.handleItemRequestError(error, todoItem, isDelete: false, completion)
                }
            }
        }
    }

    func updateRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return cache.update(todoItem.update(isDirty: true)) { _ in
                completion(TodoListServiceError.remotingDisabled)
            }
        }

        if cache.isDirty {
            cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }

            return
        }

        cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.dispatch(UpdateRemoteItemStartAction(item: todoItem))
            self?.networking.updateTodoItem(TodoItemDTO(todoItem)) { [weak self] result in
                do {
                    _ = try result.get()

                    self?.dispatch(UpdateRemoteItemSuccessAction(item: todoItem))
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.dispatch(UpdateRemoteItemErrorAction(item: todoItem, error: error))
                    self?.handleItemRequestError(error, todoItem, isDelete: false, completion)
                }
            }
        }
    }

    func removeRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return cache.delete(todoItem) { [weak self] _ in
                let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

                self?.deadItemsCache.insert(tombstone: tombstone) { _ in
                    completion(TodoListServiceError.remotingDisabled)
                }
            }
        }

        cache.delete(todoItem) { [weak self] _ in
            self?.removeRemoteRequest(todoItem, completion)
        }
    }

    private func mergeWithRemote(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }.map { TodoItemDTO($0) }
        let requestData = MergeTodoListRequestData(deleted: deleted, other: dirtyItems)

        dispatch(MergeWithRemoteItemsStartAction())
        networking.mergeTodoList(requestData) { [weak self] result in
            do {
                var todoList = try result.get().map({ TodoItem($0) })

                todoList.sortByCreateAt()
                self?.dispatch(MergeWithRemoteItemsSuccessAction(items: todoList))
                self?.deadItemsCache.clearTombstones { _ in }
                self?.currentDelay = TodoListServiceOne.minDelay
                self?.cache.replaceWith(todoList) { error in
                    completion(error)
                }
            } catch {
                self?.dispatch(MergeWithRemoteItemsErrorAction(error: error))
                self?.retryMergeRequestAfterDelay(completion)
            }
        }
    }

    private func removeRemoteRequest(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

        if cache.isDirty {
            return deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }
        }

        deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
            self?.dispatch(DeleteRemoteItemStartAction(item: todoItem))
            self?.networking.deleteTodoItem(todoItem.id) { [weak self] result in
                do {
                    _ = try result.get()

                    self?.dispatch(DeleteRemoteItemSuccessAction(item: todoItem))
                    self?.deadItemsCache.clearTombstones { _ in
                        completion(nil)
                    }
                } catch {
                    self?.dispatch(DeleteRemoteItemErrorAction(item: todoItem, error: error))
                    self?.handleItemRequestError(error, todoItem, isDelete: true, completion)
                }
            }
        }
    }

    private func retryMergeRequestAfterDelay(_ completion: @escaping (Error?) -> Void) {
        retryMergeRequestAfter(delay: currentDelay, completion)
        currentDelay = nextDelay
    }

    private func retryMergeRequestAfter(delay: Double, _ completion: @escaping (Error?) -> Void) {
        let seconds: Int = Int(delay)
        let milliseconds: Int = Int((delay - Double(seconds)) * Double(1000))
        let deadlineTime = DispatchTime.now() + .seconds(seconds) + .milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.mergeWithRemote(completion)
        }
    }

    private var nextDelay: Double {
        let delay = min(currentDelay * TodoListServiceOne.factor, TodoListServiceOne.maxDelay)
        let next = delay + delay * TodoListServiceOne.jitter * Double.random(in: -1.0...1.0)

        return next
    }

    private func handleItemRequestError(_ error: Error, _ item: TodoItem, isDelete: Bool,
                                        _ completion: @escaping (Error?) -> Void) {
        if !isDelete {
            cache.update(item.update(isDirty: true)) { [weak self] _ in
                self?.retryMergeRequestAfterDelay(completion)
            }
        } else {
            retryMergeRequestAfterDelay(completion)
        }
    }

    enum TodoListServiceError: Error {
        case remotingDisabled
    }
}
