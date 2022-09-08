//
//  ItemListAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

enum ItemListAction: Action {
    case createItem(item: TodoItem)
    case toggleItemCompletion(item: TodoItem)
    case deleteItem(item: TodoItem)
}
