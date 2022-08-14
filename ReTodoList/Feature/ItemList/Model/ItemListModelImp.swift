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
    private let thunk: ItemListThunk

    init(viewBlock: @escaping () -> ItemListView?,
         store: Store<AppState>,
         thunk: ItemListThunk) {
        self.viewBlock = viewBlock
        self.store = store
        self.thunk = thunk
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    func load() {
        store.dispatch(thunk.loadItemsFromCache)
        store.dispatch(thunk.getRemoteItems)
    }

    func create(item: TodoItem) {
        store.dispatch(CreateItemAction(item: item))
        store.dispatch(thunk.createItemInCacheAndRemote(item))
    }

    func toggleCompletionFor(item: TodoItem) {
        let updated = item.update(isCompleted: !item.isCompleted)

        store.dispatch(ToggleItemCompletionAction(item: item))
        store.dispatch(thunk.updateItemInCacheAndRemote(updated))
    }

    func delete(item: TodoItem) {
        store.dispatch(DeleteItemAction(item: item))
        store.dispatch(thunk.deleteItemInCacheAndRemote(item))
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(state: state)
    }
}
