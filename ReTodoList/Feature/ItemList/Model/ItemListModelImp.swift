//
//  ItemListModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

final class ItemListModelImp: ItemListModel, StoreSubscriber {

    private let viewBlock: () -> ItemListViewable?
    private weak var view: ItemListViewable?

    private let store: Store<AppState>
    private let service: TodoListService

    init(viewBlock: @escaping () -> ItemListViewable?,
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
    }

    func create(item: TodoItem) {
        store.dispatch(CreateItemAction(item: item))
        service.createRemote(item) { _ in

        }
    }

    func toggleCompletionFor(item: TodoItem) {
        store.dispatch(ToggleItemCompletionAction(item: item))
        service.updateRemote(item.update(isCompleted: !item.isCompleted)) { _ in

        }
    }

    func delete(item: TodoItem) {
        store.dispatch(DeleteItemAction(item: item))
        service.removeRemote(item) { _ in

        }
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(state: state)
    }
}
