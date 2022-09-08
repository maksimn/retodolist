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
    private let effect: TodoListEffect

    init(viewBlock: @escaping () -> ItemListView?,
         store: Store<AppState>,
         effect: TodoListEffect) {
        self.viewBlock = viewBlock
        self.store = store
        self.effect = effect
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
        store.dispatch(effect.loadItemsFromCache)
        store.dispatch(effect.getRemoteItemsIfNeeded)
    }

    func create(item: TodoItem) {
        store.dispatch(ItemListAction.createItem(item: item))
        store.dispatch(effect.createInCacheAndRemote(item))
    }

    func toggleCompletionFor(item: TodoItem) {
        let updatedItem = item.update(isCompleted: !item.isCompleted)

        store.dispatch(ItemListAction.toggleItemCompletion(item: item))
        store.dispatch(effect.updateInCacheAndRemote(updatedItem))
    }

    func delete(item: TodoItem) {
        store.dispatch(ItemListAction.deleteItem(item: item))
        store.dispatch(effect.deleteInCacheAndRemote(item))
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        view?.set(state: state)
    }
}
