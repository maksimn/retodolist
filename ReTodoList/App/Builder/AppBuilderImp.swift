//
//  AppBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ReSwift
import UIKit

final class AppBuilderImp: AppBuilder {

    func build() -> UIViewController {
        let loggingMiddleware: Middleware<Any> = { _, getState in
            return { next in
                return { action in

                    print("**********************************")

                    if let state = getState() {
                        print("PREVIOUS_STATE:\(state)")
                    }

                    print("\(action)")
                    print("**********************************")

                    return next(action)
                }
            }
        }

        let store = Store(
            reducer: appReducer,
            state: AppState(editorState: nil),
            middleware: [loggingMiddleware]
        )

        let navigationController = UINavigationController()
        let rootViewController = RootViewController(
            mainTitle: "Мои дела",
            navToEditorBuilder: NavToEditorBuilderImp(
                navigationController: navigationController,
                store: store
            )
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([rootViewController], animated: false)

        return navigationController
    }
}
