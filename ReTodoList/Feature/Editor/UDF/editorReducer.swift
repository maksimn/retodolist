//
//  editorReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import Foundation
import ReSwift

func editorReducer(action: Action, state: EditorState?) -> EditorState? {
    guard let action = action as? EditorAction else { return state }

    switch action {
    case .initWith(let item):
        return nextState(initEditorItem: item, state)

    case .close:
        return nil

    case .textChanged(let text):
        return nextState(textChanged: text, state)

    case .priorityChanged(let priority):
        return nextState(priorityChanged: priority, state)

    case .deadlineChanged(let deadline):
        return nextState(deadlineChanged: deadline, state)

    case .toggleDeadlinePickerVisibility:
        return nextState(toggleDeadlinePickerVisibility: state)

    case .itemSaved:
        return nextState(editorItemSaved: state)

    case .itemDeleted:
        return createEmptyState()
    }
}

private func createEmptyState() -> EditorState {
    EditorState(
        mode: .creating,
        item: TodoItem(),
        savedItem: nil,
        isDeadlinePickerHidden: true
    )
}

private func nextState(initEditorItem item: TodoItem?, _ state: EditorState?) -> EditorState? {
    let emptyState = createEmptyState()

    if let item = item {
        return EditorState(
            mode: .editing,
            item: item,
            savedItem: item,
            isDeadlinePickerHidden: emptyState.isDeadlinePickerHidden
        )
    } else {
        return emptyState
    }
}

private func nextState(textChanged text: String, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = state.item.update(text: text)

    return newState
}

private func nextState(priorityChanged priority: TodoItemPriority, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = state.item.update(priority: priority)

    return newState
}

private func nextState(deadlineChanged deadline: Date?, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = newState.item.update(deadline: deadline)

    return newState
}

private func nextState(toggleDeadlinePickerVisibility state: EditorState?) -> EditorState? {
    var state = state

    state?.isDeadlinePickerHidden.toggle()

    return state
}

private func nextState(editorItemSaved state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.mode = .editing
    newState.savedItem = state.item

    return newState
}
