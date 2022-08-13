//
//  itemListReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

func itemListReducer(action: Action, state: AppState?) -> ItemListState {
    guard let state = state else {
        return ItemListState(items: [], completedItemCount: 0, areCompleteItemsVisible: true)
    }

    switch action {
    case let action as LoadItemsFromCacheAction:
        return nextState(action, state.itemListState)

    case let action as MergeItemsWithRemoteSuccessAction:
        return nextState(action, state.itemListState)

    case let action as ItemSavedEditorAction:
        return nextState(action, state)

    case let action as ItemDeletedEditorAction:
        return nextState(action, state)

    case let action as CreateItemAction:
        return nextState(action, state.itemListState)

    case let action as ToggleItemCompletionAction:
        return nextState(action, state.itemListState)

    case let action as DeleteItemAction:
        return nextState(action, state.itemListState)

    case let action as SwitchCompletedItemsVisibilityAction:
        return nextState(action, state.itemListState)

    default:
        return state.itemListState
    }
}

private func nextState(_ action: LoadItemsFromCacheAction, _ state: ItemListState) -> ItemListState {
    var state = state

    state.items = action.items

    return state
}

private func nextState(_ action: MergeItemsWithRemoteSuccessAction, _ state: ItemListState) -> ItemListState {
    var state = state

    state.items = action.items

    return state
}

private func nextState(_ action: ItemSavedEditorAction, _ state: AppState) -> ItemListState {
    guard let item = state.editorState?.item else {
        return state.itemListState
    }
    var itemListState = state.itemListState

    if let index = itemListState.items.firstIndex(where: { $0.id == item.id }) {
        itemListState.items[index] = item
    } else {
        itemListState.items.append(item)
    }

    return itemListState
}

private func nextState(_ action: ItemDeletedEditorAction, _ state: AppState) -> ItemListState {
    guard let deletedItem = state.editorState?.item else {
        return state.itemListState
    }
    var state = state.itemListState

    if let index = state.items.firstIndex(where: { $0.id == deletedItem.id }) {
        state.items.remove(at: index)
    }

    return state
}

private func nextState(_ action: CreateItemAction, _ state: ItemListState) -> ItemListState {
    var itemListState = state

    itemListState.items.append(action.item)

    return itemListState
}

private func nextState(_ action: ToggleItemCompletionAction, _ state: ItemListState) -> ItemListState {
    var state = state
    guard let index = state.items.firstIndex(where: { $0.id == action.item.id }) else {
        return state
    }

    let item = state.items[index]
    let newItem = item.update(isCompleted: !item.isCompleted)

    state.items[index] = newItem

    if newItem.isCompleted {
        state.completedItemCount += 1
    } else if state.completedItemCount > 0 {
        state.completedItemCount -= 1
    }

    return state
}

private func nextState(_ action: DeleteItemAction, _ state: ItemListState) -> ItemListState {
    guard let index = state.items.firstIndex(where: { $0.id == action.item.id }) else { return state }
    let item = state.items[index]
    var state = state

    state.items.remove(at: index)

    if item.isCompleted && state.completedItemCount > 0 {
        state.completedItemCount -= 1
    }

    return state
}

private func nextState(_ action: SwitchCompletedItemsVisibilityAction, _ state: ItemListState) -> ItemListState {
    var state = state

    state.areCompleteItemsVisible = !state.areCompleteItemsVisible

    return state
}
