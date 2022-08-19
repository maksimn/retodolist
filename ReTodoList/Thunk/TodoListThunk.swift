//
//  ItemListThunk.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwiftThunk

protocol CUDTodoItemThunk {

    func createInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>

    func updateInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>

    func deleteInCacheAndRemote(_ item: TodoItem) -> Thunk<AppState>
}

protocol TodoListThunk: CUDTodoItemThunk {

    var loadItemsFromCache: Thunk<AppState> { get }

    var getRemoteItemsIfNeeded: Thunk<AppState> { get }
}
