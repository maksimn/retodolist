//
//  EditorAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import Foundation
import ReSwift

struct InitEditorAction: Action {
    let item: TodoItem?
}

struct CloseEditorAction: Action { }

struct TextChangedEditorAction: Action {
    let text: String
}

struct PriorityChangedEditorAction: Action {
    let priority: TodoItemPriority
}

struct DeadlineChangedEditorAction: Action {
    let deadline: Date?
}

struct DeadlinePickerVisibilityAction: Action {
    let isHidden: Bool
}

struct ItemSavedEditorAction: Action { }

struct ItemDeletedEditorAction: Action { }
