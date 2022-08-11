//
//  AppBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ReSwift
import ReSwiftRouter
import UIKit

final class UdfBuilderImp: UdfBuilder {

    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func build() -> Router<AppState> {
        let store = Store(
            reducer: appReducer,
            state: nil
        )
        let router = Router(
            store: store,
            rootRoutable: RootRoutable(
                window: window,
                store: store
            )
        ) { state in
            state.select { $0.navigationState }
        }

        store.dispatch(SetRouteAction(["Root"]))

        return router
    }
}
