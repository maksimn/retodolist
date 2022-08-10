//
//  SceneDelegate.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 09.08.2022.
//

import ReSwiftRouter
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var router: Router<AppState>?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIViewController()
        window?.rootViewController?.view.backgroundColor = Theme.data.backgroundColor

        let udfBuilder = UdfBuilderImp(window: window)

        router = udfBuilder.build()

        window?.makeKeyAndVisible()
    }
}
