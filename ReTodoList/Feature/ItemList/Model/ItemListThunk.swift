//
//  ItemListThunk.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwiftThunk

protocol ItemListThunk {

    var loadItemsFromCache: Thunk<AppState> { get }

    var getRemoteItems: Thunk<AppState> { get }

    func createItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>

    func updateItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>

    func deleteItemInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>
}
