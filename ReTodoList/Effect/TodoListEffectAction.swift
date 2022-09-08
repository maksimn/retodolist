//
//  TodoListThunkAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 20.08.2022.
//

import ReSwift

enum TodoListAction: Action {
    case loadItemsFromCache(items: [TodoItem])

    case replaceAllItemsInCacheStart
    case replaceAllItemsInCacheSuccess
    case replaceAllItemsInCacheError(Error)

    case getRemoteItemsStart
    case getRemoteItemsSuccess(items: [TodoItem])
    case getRemoteItemsError(Error)

    case mergeWithRemoteItemsStart
    case mergeWithRemoteItemsSuccess(items: [TodoItem])
    case mergeWithRemoteItemsError(Error)
}

enum InsertItemIntoCacheAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}

enum UpdateItemInCacheAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}

enum DeleteItemInCacheAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}

enum CreateRemoteItemAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}

enum UpdateRemoteItemAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}

enum DeleteRemoteItemAction: Action {
    case start(item: TodoItem)
    case success(item: TodoItem)
    case error(item: TodoItem, error: Error)
}
