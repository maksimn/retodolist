//
//  TodoListThunkAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 20.08.2022.
//

import ReSwift

struct LoadItemsFromCacheAction: Action {
    let items: [TodoItem]
}

struct InsertItemIntoCacheStartAction: Action {
    let item: TodoItem
}
struct InsertItemIntoCacheSuccessAction: Action {
    let item: TodoItem
}
struct InsertItemIntoCacheErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct UpdateItemInCacheStartAction: Action {
    let item: TodoItem
}
struct UpdateItemInCacheSuccessAction: Action {
    let item: TodoItem
}
struct UpdateItemInCacheErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct DeleteItemInCacheStartAction: Action {
    let item: TodoItem
}
struct DeleteItemInCacheSuccessAction: Action {
    let item: TodoItem
}
struct DeleteItemInCacheErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct ReplaceAllCachedItemsStartAction: Action { }
struct ReplaceAllCachedItemsSuccessAction: Action { }
struct ReplaceAllCachedItemsErrorAction: Action {
    let error: Error
}

struct GetRemoteItemsStartAction: Action { }
struct GetRemoteItemsSuccessAction: Action {
    let items: [TodoItem]
}
struct GetRemoteItemsErrorAction: Action {
    let error: Error
}

struct CreateRemoteItemStartAction: Action {
    let item: TodoItem
}
struct CreateRemoteItemSuccessAction: Action {
    let item: TodoItem
}
struct CreateRemoteItemErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct UpdateRemoteItemStartAction: Action {
    let item: TodoItem
}
struct UpdateRemoteItemSuccessAction: Action {
    let item: TodoItem
}
struct UpdateRemoteItemErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct DeleteRemoteItemStartAction: Action {
    let item: TodoItem
}
struct DeleteRemoteItemSuccessAction: Action {
    let item: TodoItem
}
struct DeleteRemoteItemErrorAction: Action {
    let item: TodoItem
    let error: Error
}

struct MergeWithRemoteItemsStartAction: Action { }
struct MergeWithRemoteItemsSuccessAction: Action {
    let items: [TodoItem]
}
struct MergeWithRemoteItemsErrorAction: Action {
    let error: Error
}
