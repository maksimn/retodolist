//
//  TodoItemCRUDModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 30.06.2021.
//

import Foundation
import ReSwift

struct IncrementNetworkRequestCountAction: Action { }

struct DecrementNetworkRequestCountAction: Action { }

struct MergeItemsWithRemoteSuccessAction: Action {
    let items: [TodoItem]
}

private let getTodoList = "GET TODOLIST"
private let createTodoItem = "CREATE TODO ITEM"
private let updateTodoItem = "UPDATE TODO ITEM"
private let deleteTodoItem = "DELETE TODO ITEM"
private let mergeTodoList = "MERGE TODOLIST"

/// Общая логика отправки и обработки сетевых запросов создания, обновления и удаления todo item'a.
class TodoListServiceOne: TodoListService {

    private let isRemotingEnabled: Bool
    private let cache: TodoListCache
    private let deadItemsCache: DeadItemsCache
    private let logger: Logger
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
         logger: Logger,
         networking: NetworkingService,
         dispatch: @escaping (Action) -> Void) {
        self.isRemotingEnabled = isRemotingEnabled
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.logger = logger
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
            mergeWithRemote(completion)
        } else {
            requestWillStart(getTodoList)
            networking.fetchTodoList { [weak self] result in
                do {
                    self?.requestDidEnd(getTodoList)

                    let fetchedItems = try result.get().map { TodoItem($0) }
                    let mergedItems = self?.cachedItems.mergeWith(fetchedItems) ?? []
                    self?.cache.replaceWith(mergedItems) { error in
                        completion(error)
                    }
                } catch {
                    self?.requestDidEnd(getTodoList, withError: error)
                    completion(error)
                }
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

        requestWillStart(createTodoItem)
        cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.createTodoItem(TodoItemDTO(todoItem)) { [weak self] result in
                do {
                    _ = try result.get()

                    self?.requestDidEnd(createTodoItem)
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.handleItemRequestError(error, todoItem, requestName: createTodoItem, completion)
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

        requestWillStart(updateTodoItem)
        cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.updateTodoItem(TodoItemDTO(todoItem)) { [weak self] result in
                do {
                    _ = try result.get()

                    self?.requestDidEnd(updateTodoItem)
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.handleItemRequestError(error, todoItem, requestName: updateTodoItem, completion)
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

    func mergeWithRemote(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }.map { TodoItemDTO($0) }
        let requestData = MergeTodoListRequestData(deleted: deleted, other: dirtyItems)

        requestWillStart(mergeTodoList)
        networking.mergeTodoList(requestData) { [weak self] result in
            do {
                var todoList = try result.get().map({ TodoItem($0) })

                todoList.sortByCreateAt()
                self?.requestDidEnd(mergeTodoList)
                self?.deadItemsCache.clearTombstones { _ in }
                self?.currentDelay = TodoListServiceOne.minDelay
                self?.cache.replaceWith(todoList) { [weak self] error in
                    self?.dispatch(MergeItemsWithRemoteSuccessAction(items: todoList))
                    completion(error)
                }
            } catch {
                self?.requestDidEnd(deleteTodoItem, withError: error)
                self?.retryMergeRequestAfterDelay(completion)
            }
        }
    }

    private func removeRemoteRequest(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

        if cache.isDirty {
            deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }
        } else {
            requestWillStart(deleteTodoItem)
            deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                self?.networking.deleteTodoItem(todoItem.id) { [weak self] result in
                    do {
                        _ = try result.get()

                        self?.requestDidEnd(deleteTodoItem)
                        self?.deadItemsCache.clearTombstones { _ in
                            completion(nil)
                        }
                    } catch {
                        self?.handleItemRequestError(error, todoItem, requestName: deleteTodoItem, completion)
                    }
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

    private func handleItemRequestError(_ error: Error, _ item: TodoItem, requestName: String,
                                        _ completion: @escaping (Error?) -> Void) {
        requestDidEnd(requestName, withError: error)

        if requestName != deleteTodoItem {
            cache.update(item.update(isDirty: true)) { [weak self] _ in
                self?.retryMergeRequestAfterDelay(completion)
            }
        } else {
            retryMergeRequestAfterDelay(completion)
        }
    }

    private func requestWillStart(_ requestName: String) {
        logger.log(message: "\n\(requestName) NETWORK REQUEST START\n")
        dispatch(IncrementNetworkRequestCountAction())
    }

    private func requestDidEnd(_ requestName: String, withError error: Error? = nil) {
        dispatch(DecrementNetworkRequestCountAction())

        if let error = error {
            logger.log(message: "\n\(requestName) NETWORK REQUEST ERROR\n")
            logger.log(error: error)
        } else {
            logger.log(message: "\n\(requestName) NETWORK REQUEST SUCCESS\n")
        }
    }

    enum TodoListServiceError: Error {
        case remotingDisabled
    }
}
