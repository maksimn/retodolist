//
//  ItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import ReSwift
import UIKit

final class ItemListBuilderImp: ItemListBuilder {

    private weak var navigationController: UINavigationController?
    private let store: Store<AppState>

    init(navigationController: UINavigationController?,
         store: Store<AppState>) {
        self.navigationController = navigationController
        self.store = store
    }

    func build() -> UIViewController {
        let router = NavToEditorRouterImp(
            navigationController: navigationController,
            editorBuilder: EditorBuilderImp(store: store)
        )

        weak var viewLazy: ItemListView?

        let model = ItemListModelImp(
            viewBlock: { viewLazy },
            store: store,
            effect: TodoListEffectImp()
        )
        let view = ItemListViewImp(
            model: model,
            navToEditorRouter: router,
            newItemCellPlaceholderText: "Новое"
        )

        viewLazy = view

        return view
    }
}
