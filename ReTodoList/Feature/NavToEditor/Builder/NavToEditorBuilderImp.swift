//
//  NavToEditorBuilderImp.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import ReSwift
import UIKit

final class NavToEditorBuilderImp: NavToEditorBuilder {

    private weak var navigationController: UINavigationController?

    private var store: Store<AppState>

    init(navigationController: UINavigationController?,
         store: Store<AppState>) {
        self.navigationController = navigationController
        self.store = store
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let editorBuilder = EditorBuilderImp(store: store)
        let router = NavToEditorRouterImp(
            navigationController: navigationController,
            editorBuilder: editorBuilder
        )
        let view = NavToEditorView(
            navigationImage: UIImage(named: "icon-plus", in: Bundle(for: type(of: self)), with: nil)!,
            router: router
        )

        return view
    }
}
