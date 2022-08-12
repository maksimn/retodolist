//
//  itemListReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import ReSwift

func itemListReducer(action: Action, state: AppState?) -> ItemListState {
    let initialState = ItemListState(
        items: [], incompleteItems: [], completeItemCount: 0, areCompleteItemsVisible: true
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

    case let action as CreateItemAction:
        itemListState.items.append(action.item)

    case let action as ToggleItemCompletionAction:
        let index = action.position

        if index > -1 && index < itemListState.items.count {
            let item = itemListState.items[index]
            let newItem = item.update(isCompleted: !item.isCompleted)

            itemListState.items[index] = newItem
        }

    case let action as DeleteItemAction:
        let index = action.position

        if index > -1 && index < itemListState.items.count {
            itemListState.items.remove(at: index)
        }

    default:
        break
    }

    return itemListState
}
