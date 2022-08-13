//
//  ItemListModel.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

protocol ItemListModel: AnyObject {

    func load()

    func create(item: TodoItem)

    func toggleCompletionFor(item: TodoItem)

    func delete(item: TodoItem)
}
