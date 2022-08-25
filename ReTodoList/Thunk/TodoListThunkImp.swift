//
//  ItemListThunkImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation
import ReSwift
import ReSwiftThunk

final class TodoListThunkImp: TodoListThunk {

    private let cache: TodoListCache
    private let deadItemsCache: DeadItemsCache
    private let service: TodoListService
    private var flags: TodoListThunkFlags

    init(cache: TodoListCache,
         deadItemsCache: DeadItemsCache,
         service: TodoListService,
         flags: TodoListThunkFlags) {
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.service = service
        self.flags = flags
    }

    var loadItemsFromCache: Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, _ in
            dispatch(LoadItemsFromCacheAction(items: self?.cache.items ?? []))
        }
    }

    var getRemoteItemsIfNeeded: Thunk<AppState> {
        Thunk<AppState> { [weak self] dispatch, getState in
            let getItemsCompleted = self?.flags.isGetRemotedItemsCompleted ?? false

            if getItemsCompleted && (self?.cache.isDirty ?? false) {
                return self?.mergeWithRemote(dispatch, getState) ?? Void()
            }

            guard !getItemsCompleted else { return }

            dispatch(GetRemoteItemsStartAction())
            dispatch(IncrementNetworkRequestCountAction())
            self?.service.getItems { [weak self] result in
                dispatch(DecrementNetworkRequestCountAction())

                switch result {
                case .success(let items):
                    dispatch(GetRemoteItemsSuccessAction(items: items))
                    self?.replaceAllCachedItemsWith(items, dispatch, isInitialGet: true)
                case .failure(let error):
                    dispatch(GetRemoteItemsErrorAction(error: error))
                }
            }
        }
    }

    func createInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
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
                        self?.mergeWithRemote(dispatch, getState)
                    }
                }
            }
        }
    }

    func deleteInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState> {
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
                        self?.mergeWithRemote(dispatch, getState)
                    }
                }
            }
        }
    }

    private func replaceAllCachedItemsWith(_ items: [TodoItem],
                                           _ dispatch: @escaping DispatchFunction,
                                           isInitialGet: Bool) {
        dispatch(ReplaceAllCachedItemsStartAction())
        cache.replaceWith(items) { [weak self] error in
            if let error = error {
                return dispatch(ReplaceAllCachedItemsErrorAction(error: error))
            }

            dispatch(ReplaceAllCachedItemsSuccessAction())

            if isInitialGet {
                self?.flags.isGetRemotedItemsCompleted = true
            }
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
                self?.replaceAllCachedItemsWith(mergedItems, dispatch, isInitialGet: false)
            case .failure(let error):
                dispatch(MergeWithRemoteItemsErrorAction(error: error))
            }
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
