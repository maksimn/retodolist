//
//  ItemListThunkImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation
import ReSwift
import ReSwiftThunk

private let initialDelay = 2

final class ItemListThunkImp: ItemListThunk {

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
            dispatch(LoadItemsFromCacheAction(items: self?.cache.items ?? []))
        }
    }

    var getRemoteItems: Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            if self?.cache.isDirty ?? false {
                return self?.mergeWithRemote(dispatch, getState) ?? Void()
            }

            dispatch(GetRemoteItemsStartAction())
            dispatch(IncrementNetworkRequestCountAction())
            self?.service.getItems { [weak self] result in
                dispatch(DecrementNetworkRequestCountAction())

                switch result {
                case .success(let items):
                    let mergedItems = mergedItemsFrom(remoteItems: items, getState)

                    dispatch(GetRemoteItemsSuccessAction(items: mergedItems))
                    self?.replaceAllCachedItemsWith(mergedItems, dispatch)
                case .failure(let error):
                    dispatch(GetRemoteItemsErrorAction(error: error))
                }
            }
        }
    }

    func createItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            let dirtyItem = item.update(isDirty: true)

            if self?.cache.isDirty ?? false {
                dispatch(InsertItemIntoCacheStartAction(item: dirtyItem))
                self?.cache.insert(dirtyItem) { [weak self] error in
                    if let error = error {
                        return dispatch(InsertItemIntoCacheErrorAction(item: dirtyItem, error: error))
                    }

                    dispatch(InsertItemIntoCacheSuccessAction(item: dirtyItem))
                    self?.mergeWithRemote(dispatch, getState)
                }
                return
            }

            dispatch(InsertItemIntoCacheStartAction(item: dirtyItem))
            self?.cache.insert(dirtyItem) { error in
                if let error = error {
                    return dispatch(InsertItemIntoCacheErrorAction(item: dirtyItem, error: error))
                }

                dispatch(InsertItemIntoCacheSuccessAction(item: dirtyItem))
                dispatch(CreateRemoteItemStartAction(item: item))
                dispatch(IncrementNetworkRequestCountAction())
                self?.service.createRemote(item) { result in
                    dispatch(DecrementNetworkRequestCountAction())

                    switch result {
                    case .success:
                        dispatch(CreateRemoteItemSuccessAction(item: item))
                        dispatch(UpdateItemInCacheStartAction(item: item))
                        self?.cache.update(item) { error in
                            if let error = error {
                                return dispatch(UpdateItemInCacheErrorAction(item: item, error: error))
                            }

                            dispatch(UpdateItemInCacheSuccessAction(item: item))
                        }
                    case .failure(let error):
                        dispatch(CreateRemoteItemErrorAction(item: item, error: error))
                        self?.retryMergeWithRemoteAfterDelay(initialDelay, dispatch, getState)
                    }
                }
            }
        }
    }

    func updateItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            let dirtyItem = item.update(isDirty: true)

            if self?.cache.isDirty ?? false {
                dispatch(UpdateItemInCacheStartAction(item: dirtyItem))
                self?.cache.update(dirtyItem) { error in
                    if let error = error {
                        return dispatch(UpdateItemInCacheErrorAction(item: dirtyItem, error: error))
                    }

                    dispatch(UpdateItemInCacheSuccessAction(item: dirtyItem))
                    self?.mergeWithRemote(dispatch, getState)
                }
                return
            }

            dispatch(UpdateItemInCacheStartAction(item: dirtyItem))
            self?.cache.update(dirtyItem) { error in
                if let error = error {
                    return dispatch(UpdateItemInCacheErrorAction(item: item, error: error))
                }

                dispatch(UpdateItemInCacheSuccessAction(item: dirtyItem))
                dispatch(UpdateRemoteItemStartAction(item: item))
                dispatch(IncrementNetworkRequestCountAction())
                self?.service.updateRemote(item) { result in
                    dispatch(DecrementNetworkRequestCountAction())

                    switch result {
                    case .success:
                        dispatch(UpdateRemoteItemSuccessAction(item: item))
                        dispatch(UpdateItemInCacheStartAction(item: item))
                        self?.cache.update(item) { error in
                            if let error = error {
                                return dispatch(UpdateItemInCacheErrorAction(item: item, error: error))
                            }

                            dispatch(UpdateItemInCacheSuccessAction(item: item))
                        }
                    case .failure(let error):
                        dispatch(UpdateRemoteItemErrorAction(item: item, error: error))
                        self?.retryMergeWithRemoteAfterDelay(initialDelay, dispatch, getState)
                    }
                }
            }
        }
    }

    func deleteItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            dispatch(DeleteItemInCacheStartAction(item: item))
            self?.cache.delete(item) { error in
                if let error = error {
                    return dispatch(DeleteItemInCacheErrorAction(item: item, error: error))
                }

                dispatch(DeleteItemInCacheSuccessAction(item: item))

                if self?.cache.isDirty ?? false {
                    let tombstone = Tombstone(itemId: item.id, deletedAt: Date())

                    self?.deadItemsCache.insert(tombstone: tombstone) { _ in
                        self?.mergeWithRemote(dispatch, getState)
                    }
                    return
                }

                dispatch(DeleteRemoteItemStartAction(item: item))
                dispatch(IncrementNetworkRequestCountAction())
                self?.service.deleteRemote(item) { [weak self] result in
                    dispatch(DecrementNetworkRequestCountAction())

                    switch result {
                    case .success:
                        dispatch(DeleteRemoteItemSuccessAction(item: item))
                    case .failure(let error):
                        let tombstone = Tombstone(itemId: item.id, deletedAt: Date())

                        self?.deadItemsCache.insert(tombstone: tombstone) { _ in

                        }
                        dispatch(DeleteRemoteItemErrorAction(item: item, error: error))
                        self?.retryMergeWithRemoteAfterDelay(initialDelay, dispatch, getState)
                    }
                }
            }
        }
    }

    private func replaceAllCachedItemsWith(_ mergedItems: [TodoItem], _ dispatch: @escaping DispatchFunction) {
        dispatch(ReplaceAllCachedItemsStartAction())
        cache.replaceWith(mergedItems) { error in
            if let error = error {
                return dispatch(ReplaceAllCachedItemsErrorAction(error: error))
            }

            dispatch(ReplaceAllCachedItemsSuccessAction())
        }
    }

    private func mergeWithRemote(_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> AppState?) {
        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }

        dispatch(MergeWithRemoteItemsStartAction())
        dispatch(IncrementNetworkRequestCountAction())
        service.mergeWithRemote(deleted, dirtyItems) { [weak self] result in
            dispatch(DecrementNetworkRequestCountAction())

            switch result {
            case .success(let items):
                let mergedItems = mergedItemsFrom(remoteItems: items, getState)

                dispatch(MergeWithRemoteItemsSuccessAction(items: mergedItems))
                self?.deadItemsCache.clearTombstones { _ in }
                self?.replaceAllCachedItemsWith(mergedItems, dispatch)
            case .failure(let error):
                dispatch(MergeWithRemoteItemsErrorAction(error: error))
            }
        }
    }

    private func retryMergeWithRemoteAfterDelay(_ seconds: Int,
                                                _ dispatch: @escaping DispatchFunction,
                                                _ getState: @escaping () -> AppState?) {
        let deadlineTime = DispatchTime.now() + .seconds(seconds)

        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self, getState] in
            self?.mergeWithRemote(dispatch, getState)
        }
    }
}

private func mergedItemsFrom(remoteItems: [TodoItem], _ getState: () -> AppState?) -> [TodoItem] {
    guard let state = getState() else {
        return remoteItems
    }
    let currentItems = state.itemListState.items

    return currentItems.mergeWith(remoteItems)
}