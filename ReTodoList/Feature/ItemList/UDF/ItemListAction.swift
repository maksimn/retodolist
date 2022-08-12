//
//  ItemListAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

struct CreateItemAction: Action {
    let item: TodoItem
}

struct ToggleItemCompletionAction: Action {
    let item: TodoItem
}

struct DeleteItemAction: Action {
    let item: TodoItem
}
