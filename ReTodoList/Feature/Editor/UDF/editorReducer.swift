//
//  editorReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

// swiftlint:disable cyclomatic_complexity function_body_length
func editorReducer(action: Action, state: EditorState?) -> EditorState? {
    let isDeadlinePickerHiddenByDefault = true
    let emptyEditorState = EditorState(
        mode: .creating,
        item: TodoItem(),
        savedItem: nil,
        isDeadlinePickerHidden: isDeadlinePickerHiddenByDefault
    )

    switch action {

    case let action as InitEditorAction:
        if let item = action.item {
            return EditorState(
                mode: .editing,
                item: item,
                savedItem: item,
                isDeadlinePickerHidden: isDeadlinePickerHiddenByDefault
            )
        } else {
            return emptyEditorState
        }

    case _ as CloseEditorAction:
        return nil

    case let action as TextChangedEditorAction:
        guard let state = state else { return state }
        var newState = state

        newState.item = state.item.update(text: action.text)

        return newState

    case let action as PriorityChangedEditorAction:
        guard let state = state else { return state }
        var newState = state

        newState.item = state.item.update(priority: action.priority)

        return newState

    case let action as DeadlineChangedEditorAction:
        guard let state = state else { return state }
        var newState = state

        newState.item.deadline = action.deadline

        return newState

    case let action as DeadlinePickerVisibilityAction:
        var state = state

        state?.isDeadlinePickerHidden = action.isHidden

        return state

    case _ as ItemSavedEditorAction:
        guard let state = state else { return state }
        var newState = state

        newState.mode = .editing
        newState.savedItem = state.item

        return newState

    case _ as ItemDeletedEditorAction:
        return emptyEditorState

    default:
        break
    }

    return state
}
