//
//  VisibilitySwitchModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

final class VisibilitySwitchModelImp: VisibilitySwitchModel, StoreSubscriber {

    private let viewBlock: () -> VisibilitySwitchView?
    private weak var view: VisibilitySwitchView?
    private let store: Store<AppState>

    init(viewBlock: @escaping () -> VisibilitySwitchView?,
         store: Store<AppState>) {
        self.viewBlock = viewBlock
        self.store = store
    }

    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        view?.set(state: state)
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
}
