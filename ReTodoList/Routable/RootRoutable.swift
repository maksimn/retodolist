//
//  RootRoutable.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import ReSwiftRouter
import UIKit

final class RootRoutable: Routable {

    private weak var window: UIWindow?
    private let store: Store<AppState>

    init(window: UIWindow?,
         store: Store<AppState>) {
        self.window = window
        self.store = store
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        completionHandler()

        let navigationController = UINavigationController()
        let rootViewController = RootViewController(store: store)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([rootViewController], animated: false)

        window?.rootViewController = navigationController

        return EditorRoutable(
            navigationController: navigationController,
            editorBuilder: EditorBuilderImp(store: store)
        )
    }
}
