//
//  NetworkIndicatorModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

final class NetworkIndicatorModelImp: NetworkIndicatorModel, StoreSubscriber {

    private let viewBlock: () -> NetworkIndicatorView?
    private weak var view: NetworkIndicatorView?
    private let store: Store<AppState>

    init(viewBlock: @escaping () -> NetworkIndicatorView?,
         store: Store<AppState>) {
        self.viewBlock = viewBlock
        self.store = store
    }

    func subscribe() {
        if view == nil {
            view = viewBlock()
        }

        store.subscribe(self) { subcription in
            subcription.select { state in state.networkIndicatorState }
        }
    }

    func newState(state: NetworkIndicatorState?) {
        guard let state = state else { return }

        view?.set(visible: state.pendingRequestCount > 0)
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
