//
//  NetworkIndicatorAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

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
