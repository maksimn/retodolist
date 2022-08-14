//
//  NetworkIndicatorAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

protocol GetRemoteItemsAction: Action { }

struct GetRemoteItemsStartAction: GetRemoteItemsAction { }

struct GetRemoteItemsSuccessAction: GetRemoteItemsAction {
    let items: [TodoItem]
}

struct GetRemoteItemsErrorAction: GetRemoteItemsAction {
    let error: Error
}

protocol CreateRemoteItemAction: Action { }

struct CreateRemoteItemStartAction: CreateRemoteItemAction {
    let item: TodoItem
}

struct CreateRemoteItemSuccessAction: CreateRemoteItemAction {
    let item: TodoItem
}

struct CreateRemoteItemErrorAction: CreateRemoteItemAction {
    let item: TodoItem
    let error: Error
}

protocol UpdateRemoteItemAction: Action { }

struct UpdateRemoteItemStartAction: UpdateRemoteItemAction {
    let item: TodoItem
}

struct UpdateRemoteItemSuccessAction: UpdateRemoteItemAction {
    let item: TodoItem
}

struct UpdateRemoteItemErrorAction: UpdateRemoteItemAction {
    let item: TodoItem
    let error: Error
}

protocol DeleteRemoteItemAction: Action { }

struct DeleteRemoteItemStartAction: DeleteRemoteItemAction {
    let item: TodoItem
}

struct DeleteRemoteItemSuccessAction: DeleteRemoteItemAction {
    let item: TodoItem
}

struct DeleteRemoteItemErrorAction: DeleteRemoteItemAction {
    let item: TodoItem
    let error: Error
}

protocol MergeWithRemoteItemsAction: Action { }

struct MergeWithRemoteItemsStartAction: MergeWithRemoteItemsAction { }

struct MergeWithRemoteItemsSuccessAction: MergeWithRemoteItemsAction {
    let items: [TodoItem]
}

struct MergeWithRemoteItemsErrorAction: MergeWithRemoteItemsAction {
    let error: Error
}
