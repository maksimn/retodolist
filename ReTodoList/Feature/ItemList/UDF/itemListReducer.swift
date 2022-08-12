//
//  itemListReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

// swiftlint:disable cyclomatic_complexity
func itemListReducer(action: Action, state: AppState?) -> ItemListState {
    let initialState = ItemListState(
        items: [], incompleteItems: [], completedItemCount: 0, areCompleteItemsVisible: true
    )
    guard let state = state else {
        return state?.itemListState ?? initialState
    }
    var itemListState = state.itemListState

    switch action {
    case _ as ItemSavedEditorAction:
        guard let item = state.editorState?.item else {
            return state.itemListState
        }

        if let index = itemListState.items.firstIndex(where: { $0.id == item.id }) {
            itemListState.items[index] = item
        } else {
            itemListState.items.append(item)
        }

    case _ as ItemDeletedEditorAction:
        guard let deletedItem = state.editorState?.item else { return itemListState }

        if let index = state.itemListState.items.firstIndex(where: { $0.id == deletedItem.id }) {
            return stateAfterItemDeletionWith(index: index, state: itemListState)
        }

    case let action as CreateItemAction:
        itemListState.items.append(action.item)

    case let action as ToggleItemCompletionAction:
        let index = action.position

        if index > -1 && index < itemListState.items.count {
            let item = itemListState.items[index]
            let newItem = item.update(isCompleted: !item.isCompleted)

            itemListState.items[index] = newItem

            if newItem.isCompleted {
                itemListState.completedItemCount += 1
            } else if itemListState.completedItemCount > 0 {
                itemListState.completedItemCount -= 1
            }
        }

    case let action as DeleteItemAction:
        return stateAfterItemDeletionWith(index: action.position, state: itemListState)

    default:
        break
    }

    return itemListState
}

private func stateAfterItemDeletionWith(index: Int, state: ItemListState) -> ItemListState {
    var state = state

    if index > -1 && index < state.items.count {
        let item = state.items[index]

        state.items.remove(at: index)

        if item.isCompleted && state.completedItemCount > 0 {
            state.completedItemCount -= 1
        }
    }

    return state
}
