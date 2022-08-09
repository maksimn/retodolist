//
//  SceneDelegate.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 09.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appBuilder = AppBuilderImp()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appBuilder.build()
        window?.makeKeyAndVisible()
    }
}
