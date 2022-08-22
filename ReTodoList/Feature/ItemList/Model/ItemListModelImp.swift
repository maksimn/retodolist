//
//  ItemListModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

final class ItemListModelImp: ItemListModel, StoreSubscriber {

    private let viewBlock: () -> ItemListView?
    private weak var view: ItemListView?

    private let store: Store<AppState>
    private let thunk: TodoListThunk

    init(viewBlock: @escaping () -> ItemListView?,
         store: Store<AppState>,
         thunk: TodoListThunk) {
        self.viewBlock = viewBlock
        self.store = store
        self.thunk = thunk
    }

    func subscribe() {
        if view == nil {
            view = viewBlock()
        }

        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }

    func load() {
        store.dispatch(thunk.loadItemsFromCache)
        store.dispatch(thunk.getRemoteItemsIfNeeded)
    }

    func create(item: TodoItem) {
        store.dispatch(CreateItemAction(item: item))
        store.dispatch(thunk.createInCacheAndRemote(item))
    }

    func toggleCompletionFor(item: TodoItem) {
        let updatedItem = item.update(isCompleted: !item.isCompleted)

        store.dispatch(ToggleItemCompletionAction(item: item))
        store.dispatch(thunk.updateInCacheAndRemote(updatedItem))
    }

    func delete(item: TodoItem) {
        store.dispatch(DeleteItemAction(item: item))
        store.dispatch(thunk.deleteInCacheAndRemote(item))
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        view?.set(state: state)
    }
}
