//
//  EditorState.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

enum EditorMode { case creating, editing }

struct EditorState {
    var mode: EditorMode
    var item: TodoItem
    var savedItem: TodoItem?
    var isDeadlinePickerHidden: Bool
}

extension EditorState {

    var canItemBeSaved: Bool {
        let isStateAfterSaving = mode == .editing && item == savedItem

        return !isInitialState && !isStateAfterSaving
    }

    var canItemBeRemoved: Bool {
        !isInitialState
    }

    private var isInitialState: Bool {
        let empty = TodoItem()

        return mode == .creating &&
            savedItem == nil &&
            item.text == empty.text &&
            item.priority == empty.priority &&
            item.deadline == empty.deadline
    }
}
