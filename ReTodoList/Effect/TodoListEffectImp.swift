//
//  ItemListThunkImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation
import ReSwift
import ReSwiftThunk

final class TodoListEffectImp: TodoListEffect {

    private let cache: TodoListCache
    private let deadItemsCache: DeadItemsCache
    private let service: TodoListService

    init(cache: TodoListCache,
         deadItemsCache: DeadItemsCache,
         service: TodoListService) {
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.service = service
    }

    var loadItemsFromCache: Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, _ in
            dispatch(TodoListAction.loadItemsFromCache(items: self?.cache.items ?? []))
        }
    }

    var getRemoteItemsIfNeeded: Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            guard let self = self else { return }

            if self.cache.isDirty {
                return self.mergeWithRemote(dispatch, getState)
            }

            dispatch(TodoListAction.getRemoteItemsStart)
            dispatch(NetworkIndicatorAction.incrementNetworkRequestCount)
            self.service.getItems { [weak self] result in
                dispatch(NetworkIndicatorAction.decrementNetworkRequestCount)

                switch result {
                case .success(let items):
                    self?.complete(operation: .get, items, dispatch)
                case .failure(let error):
                    dispatch(TodoListAction.getRemoteItemsError(error))
                }
            }
        }
    }

    func createInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            let dirtyItem = item.update(isDirty: true)

            if self?.cache.isDirty ?? false {
                dispatch(InsertItemIntoCacheAction.start(item: dirtyItem))
                self?.cache.insert(dirtyItem) { [weak self] error in
                    if let error = error {
                        return dispatch(InsertItemIntoCacheAction.error(item: dirtyItem, error: error))
                    }

                    dispatch(InsertItemIntoCacheAction.success(item: dirtyItem))
                    self?.mergeWithRemote(dispatch, getState)
                }
                return
            }

            dispatch(InsertItemIntoCacheAction.start(item: dirtyItem))
            self?.cache.insert(dirtyItem) { error in
                if let error = error {
                    return dispatch(InsertItemIntoCacheAction.error(item: dirtyItem, error: error))
                }

                dispatch(InsertItemIntoCacheAction.success(item: dirtyItem))
                dispatch(CreateRemoteItemAction.start(item: item))
                dispatch(NetworkIndicatorAction.incrementNetworkRequestCount)
                self?.service.createRemote(item) { result in
                    dispatch(NetworkIndicatorAction.decrementNetworkRequestCount)

                    switch result {
                    case .success:
                        dispatch(CreateRemoteItemAction.success(item: item))
                        dispatch(UpdateItemInCacheAction.start(item: item))
                        self?.cache.update(item) { error in
                            if let error = error {
                                return dispatch(UpdateItemInCacheAction.error(item: item, error: error))
                            }

                            dispatch(UpdateItemInCacheAction.success(item: item))
                        }
                    case .failure(let error):
                        dispatch(CreateRemoteItemAction.error(item: item, error: error))
                        self?.mergeWithRemote(dispatch, getState)
                    }
                }
            }
        }
    }

    func updateInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            let dirtyItem = item.update(isDirty: true)

            if self?.cache.isDirty ?? false {
                dispatch(UpdateItemInCacheAction.start(item: dirtyItem))
                self?.cache.update(dirtyItem) { error in
                    if let error = error {
                        return dispatch(UpdateItemInCacheAction.error(item: dirtyItem, error: error))
                    }

                    dispatch(UpdateItemInCacheAction.success(item: dirtyItem))
                    self?.mergeWithRemote(dispatch, getState)
                }
                return
            }

            dispatch(UpdateItemInCacheAction.start(item: dirtyItem))
            self?.cache.update(dirtyItem) { error in
                if let error = error {
                    return dispatch(UpdateItemInCacheAction.error(item: item, error: error))
                }

                dispatch(UpdateItemInCacheAction.success(item: dirtyItem))
                dispatch(UpdateRemoteItemAction.start(item: item))
                dispatch(NetworkIndicatorAction.incrementNetworkRequestCount)
                self?.service.updateRemote(item) { result in
                    dispatch(NetworkIndicatorAction.decrementNetworkRequestCount)

                    switch result {
                    case .success:
                        dispatch(UpdateRemoteItemAction.success(item: item))
                        dispatch(UpdateItemInCacheAction.start(item: item))
                        self?.cache.update(item) { error in
                            if let error = error {
                                return dispatch(UpdateItemInCacheAction.error(item: item, error: error))
                            }

                            dispatch(UpdateItemInCacheAction.success(item: item))
                        }
                    case .failure(let error):
                        dispatch(UpdateRemoteItemAction.error(item: item, error: error))
                        self?.mergeWithRemote(dispatch, getState)
                    }
                }
            }
        }
    }

    func deleteInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            dispatch(DeleteItemInCacheAction.start(item: item))
            self?.cache.delete(item) { error in
                if let error = error {
                    return dispatch(DeleteItemInCacheAction.error(item: item, error: error))
                }

                dispatch(DeleteItemInCacheAction.success(item: item))

                if self?.cache.isDirty ?? false {
                    let tombstone = Tombstone(itemId: item.id, deletedAt: Date())

                    self?.deadItemsCache.insert(tombstone: tombstone) { _ in
                        self?.mergeWithRemote(dispatch, getState)
                    }
                    return
                }

                dispatch(DeleteRemoteItemAction.start(item: item))
                dispatch(NetworkIndicatorAction.incrementNetworkRequestCount)
                self?.service.deleteRemote(item) { [weak self] result in
                    dispatch(NetworkIndicatorAction.decrementNetworkRequestCount)

                    switch result {
                    case .success:
                        dispatch(DeleteRemoteItemAction.success(item: item))
                    case .failure(let error):
                        let tombstone = Tombstone(itemId: item.id, deletedAt: Date())

                        self?.deadItemsCache.insert(tombstone: tombstone) { _ in

                        }
                        dispatch(DeleteRemoteItemAction.error(item: item, error: error))
                        self?.mergeWithRemote(dispatch, getState)
                    }
                }
            }
        }
    }

    private func complete(operation: TodoListOperation, _ items: [TodoItem], _ dispatch: @escaping DispatchFunction) {
        dispatch(TodoListAction.replaceAllItemsInCacheStart)
        cache.replaceWith(items) { error in
            if let error = error {
                dispatch(TodoListAction.replaceAllItemsInCacheError(error))

                switch operation {
                case .get:
                    dispatch(TodoListAction.getRemoteItemsError(error))
                case .merge:
                    dispatch(TodoListAction.mergeWithRemoteItemsError(error))
                }

                return
            }

            dispatch(TodoListAction.replaceAllItemsInCacheSuccess)

            switch operation {
            case .get:
                dispatch(TodoListAction.getRemoteItemsSuccess(items: items))
            case .merge:
                dispatch(TodoListAction.mergeWithRemoteItemsSuccess(items: items))
            }
        }
    }

    private func mergeWithRemote(_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> AppState?) {
        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }

        dispatch(TodoListAction.mergeWithRemoteItemsStart)
        dispatch(NetworkIndicatorAction.incrementNetworkRequestCount)
        service.mergeWithRemote(deleted, dirtyItems) { [weak self] result in
            dispatch(NetworkIndicatorAction.decrementNetworkRequestCount)

            switch result {
            case .success(let items):
                let mergedItems = mergedItemsFrom(remoteItems: items, getState)

                self?.deadItemsCache.clearTombstones { _ in }
                self?.complete(operation: .merge, mergedItems, dispatch)
            case .failure(let error):
                dispatch(TodoListAction.mergeWithRemoteItemsError(error))
            }
        }
    }

    private enum TodoListOperation { case get, merge }
}

private func mergedItemsFrom(remoteItems: [TodoItem], _ getState: () -> AppState?) -> [TodoItem] {
    guard let state = getState() else {
        return remoteItems
    }
    let currentItems = state.itemListState.items

    return currentItems.mergeWith(remoteItems)
}
