//
//  EditorRoutable.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwiftRouter
import UIKit

final class EditorRoutable: Routable {

    private weak var navigationController: UINavigationController?
    private let editorBuilder: EditorBuilder

    init(navigationController: UINavigationController?,
         editorBuilder: EditorBuilder) {
        self.navigationController = navigationController
        self.editorBuilder = editorBuilder
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        if routeElementIdentifier == "Editor" {
            completionHandler()

            let editorViewController = editorBuilder.build()

            editorViewController.modalPresentationStyle = .overFullScreen
            editorViewController.navigationItem.largeTitleDisplayMode = .never

            let otherNavigationController = UINavigationController(rootViewController: editorViewController)

            navigationController?.topViewController?.present(otherNavigationController, animated: true, completion: nil)
        }

        return EmptyRoutable()
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {
        if routeElementIdentifier == "Editor" {
            navigationController?.topViewController?.dismiss(animated: animated, completion: completionHandler)
        }
    }
}
