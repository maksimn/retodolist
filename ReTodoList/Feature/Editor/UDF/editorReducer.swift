//
//  editorReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

func editorReducer(action: Action, state: EditorState?) -> EditorState? {
    switch action {

    case let action as InitEditorAction:
        return nextState(action, state)

    case _ as CloseEditorAction:
        return nil

    case let action as TextChangedEditorAction:
        return nextState(action, state)

    case let action as PriorityChangedEditorAction:
        return nextState(action, state)

    case let action as DeadlineChangedEditorAction:
        return nextState(action, state)

    case let action as DeadlinePickerVisibilityAction:
        return nextState(action, state)

    case let action as EditorItemSavedAction:
        return nextState(action, state)

    case _ as EditorItemDeletedAction:
        return createEmptyState()

    default:
        return state
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

private func nextState(_ action: InitEditorAction, _ state: EditorState?) -> EditorState? {
    let emptyState = createEmptyState()

    if let item = action.item {
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

private func nextState(_ action: TextChangedEditorAction, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = state.item.update(text: action.text)

    return newState
}

private func nextState(_ action: PriorityChangedEditorAction, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = state.item.update(priority: action.priority)

    return newState
}

private func nextState(_ action: DeadlineChangedEditorAction, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.item = newState.item.update(deadline: action.deadline)

    return newState
}

private func nextState(_ action: DeadlinePickerVisibilityAction, _ state: EditorState?) -> EditorState? {
    var state = state

    state?.isDeadlinePickerHidden = action.isHidden

    return state
}

private func nextState(_ action: EditorItemSavedAction, _ state: EditorState?) -> EditorState? {
    guard let state = state else { return state }
    var newState = state

    newState.mode = .editing
    newState.savedItem = state.item

    return newState
}
