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

    init(viewBlock: @escaping () -> ItemListView?,
         store: Store<AppState>) {
        self.viewBlock = viewBlock
        self.store = store
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    func load() {
    }

    func create(item: TodoItem) {
        store.dispatch(CreateItemAction(item: item))
    }

    func toggleCompletionFor(item: TodoItem) {
        store.dispatch(ToggleItemCompletionAction(item: item))
    }

    func delete(item: TodoItem) {
        store.dispatch(DeleteItemAction(item: item))
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(state: state)
    }
}
