//
//  AppBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class AppBuilderImp: AppBuilder {

    func build() -> UIViewController {
        let navigationController = UINavigationController()
        let rootViewController = RootViewController(
            mainTitle: "Мои дела",
            navToEditorBuilder: NavToEditorBuilderImp(navigationController: navigationController)
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([rootViewController], animated: false)

        return navigationController
    }
}
