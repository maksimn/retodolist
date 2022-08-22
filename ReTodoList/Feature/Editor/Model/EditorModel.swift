//
//  EditorModel.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation

protocol EditorModel {

    func subscribe()

    func unsubscribe()

    func setInitial(item: TodoItem?)

    func set(deadline: Date?)

    func set(isDeadlinePickerHidden: Bool)

    func set(text: String)

    func set(priority: TodoItemPriority)

    func save()

    func delete()

    func close()
}
