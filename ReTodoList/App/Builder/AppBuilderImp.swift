//
//  AppBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ReSwift
import ReSwiftThunk
import UIKit

final class AppBuilderImp: AppBuilder {

    func build() -> UIViewController {
        let isLoggingLongOutputEnabled = false
        let loggingMiddleware: Middleware<Any> = { _, getState in
            return { next in
                return { action in

                    print("**********************************")

                    if isLoggingLongOutputEnabled, let state = getState() {
                        print("PREVIOUS_STATE:\(state)")
                    }

                    print("\(action)")
                    print("**********************************")

                    return next(action)
                }
            }
        }

        let thunkMiddleware: Middleware<AppState> = createThunkMiddleware()

        let initialState = AppState(
            itemListState: ItemListState(
                items: [],
                completedItemCount: 0,
                areCompleteItemsVisible: false
            ),
            editorState: nil,
            networkIndicatorState: NetworkIndicatorState(pendingRequestCount: 0)
        )
        let store = Store(
            reducer: appReducer,
            state: initialState,
            middleware: [loggingMiddleware, thunkMiddleware]
        )

        let navigationController = UINavigationController()
        let rootViewController = RootViewController(
            mainTitle: "Мои дела",
            counterBuilder: CounterBuilderImp(store: store),
            visibilitySwitchBuilder: VisibilitySwitchBuilderImp(store: store),
            itemListBuilder: ItemListBuilderImp(
                navigationController: navigationController,
                store: store
            ),
            navToEditorBuilder: NavToEditorBuilderImp(
                navigationController: navigationController,
                store: store
            ),
            networkIndicatorBuilder: NetworkIndicatorBuilderImp(store: store)
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([rootViewController], animated: false)

        return navigationController
    }
}
