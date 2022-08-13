//
//  CounterModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

final class CounterModelImp: CounterModel, StoreSubscriber {

    private let viewBlock: () -> CounterView?
    private weak var view: CounterView?
    private let store: Store<AppState>

    init(viewBlock: @escaping () -> CounterView?,
         store: Store<AppState>) {
        self.viewBlock = viewBlock
        self.store = store
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(count: state.completedItemCount)
    }
}
