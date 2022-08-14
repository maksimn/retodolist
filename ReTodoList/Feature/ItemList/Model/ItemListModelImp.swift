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
    private let service: TodoListService

    init(viewBlock: @escaping () -> ItemListView?,
         store: Store<AppState>,
         service: TodoListService) {
        self.viewBlock = viewBlock
        self.store = store
        self.service = service
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    func load() {
        store.dispatch(
            LoadItemsFromCacheAction(items: service.cachedItems)
        )
        store.dispatch(getRemoteItems(withService: service))
    }

    func create(item: TodoItem) {
        store.dispatch(CreateItemAction(item: item))
        store.dispatch(createRemoteItem(item, withService: service))
    }

    func toggleCompletionFor(item: TodoItem) {
        let updatedItem = item.update(isCompleted: !item.isCompleted)

        store.dispatch(ToggleItemCompletionAction(item: item))
        store.dispatch(updateRemoteItem(updatedItem, withService: service))
    }

    func delete(item: TodoItem) {
        store.dispatch(DeleteItemAction(item: item))
        store.dispatch(deleteRemoteItem(item, withService: service))
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(state: state)
    }
}
