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
    case TodoListAction.loadItemsFromCache(let items),
         TodoListAction.getRemoteItemsSuccess(let items),
         TodoListAction.mergeWithRemoteItemsSuccess(let items):
        return nextState(forNewItems: items, state: state.itemListState)

    case EditorAction.itemSaved:
        return nextState(editorItemSaved: state)

    case EditorAction.itemDeleted:
        return nextState(editorItemDeleted: state)

    case ItemListAction.createItem(let item):
        return nextState(createItem: item, state.itemListState)

    case ItemListAction.toggleItemCompletion(let item):
        return nextState(toggleItemCompletion: item, state.itemListState)

    case ItemListAction.deleteItem(let item):
        return nextState(deleteItem: item, state.itemListState)

    case VisibilitySwitchAction.toggleCompletedItemsVisibility:
        return nextState(toggleCompletedItemsVisibility: state.itemListState)

    default:
        return state.itemListState
    }
}

private func nextState(forNewItems items: [TodoItem], state: ItemListState) -> ItemListState {
    var state = state

    state.items = items
    state.completedItemCount = items.filter({ $0.isCompleted }).count

    return state
}

private func nextState(editorItemSaved state: AppState) -> ItemListState {
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

private func nextState(editorItemDeleted state: AppState) -> ItemListState {
    guard let deletedItem = state.editorState?.item else {
        return state.itemListState
    }
    var state = state.itemListState

    if let index = state.items.firstIndex(where: { $0.id == deletedItem.id }) {
        state.items.remove(at: index)
    }

    return state
}

private func nextState(createItem item: TodoItem, _ state: ItemListState) -> ItemListState {
    var itemListState = state

    itemListState.items.append(item)

    return itemListState
}

private func nextState(toggleItemCompletion item: TodoItem, _ state: ItemListState) -> ItemListState {
    var state = state
    guard let index = state.items.firstIndex(where: { $0.id == item.id }) else {
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

private func nextState(deleteItem item: TodoItem, _ state: ItemListState) -> ItemListState {
    guard let index = state.items.firstIndex(where: { $0.id == item.id }) else { return state }
    let item = state.items[index]
    var state = state

    state.items.remove(at: index)

    if item.isCompleted && state.completedItemCount > 0 {
        state.completedItemCount -= 1
    }

    return state
}

private func nextState(toggleCompletedItemsVisibility state: ItemListState) -> ItemListState {
    var state = state

    state.areCompleteItemsVisible.toggle()

    return state
}
