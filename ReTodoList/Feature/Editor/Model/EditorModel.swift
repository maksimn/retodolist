//
//  EditorModel.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation

protocol EditorModel: UDFModel {

    func initialize()

    func set(deadline: Date?)

    func toggleDeadlinePickerVisibility()

    func set(text: String)

    func set(priority: TodoItemPriority)

    func save()

    func delete()

    func close()
}
