//
//  NavigationEffectImpl.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 08.09.2022.
//

import UIKit
import ReSwiftThunk

final class NavigationEffectImpl: NavigationEffect {

    private weak var navigationController: UINavigationController?
    private let editorBuilder: EditorBuilder

    init(navigationController: UINavigationController?,
         editorBuilder: EditorBuilder) {
        self.navigationController = navigationController
        self.editorBuilder = editorBuilder
    }

    func showEditor(item: TodoItem?) -> Thunk<AppState> {
        Thunk<AppState> { [weak self] _, _ in
            guard let self = self else { return }
            let editorViewController = self.editorBuilder.build(initTodoItem: item)
            let otherNavigationController = UINavigationController(rootViewController: editorViewController)

            otherNavigationController.modalPresentationStyle = .overFullScreen

            self.navigationController?.topViewController?.present(otherNavigationController, animated: true)
        }
    }

    func hideEditor() -> Thunk<AppState> {
        Thunk<AppState> { [weak self] _, _ in
            self?.navigationController?.topViewController?.dismiss(animated: true)
        }
    }
}
