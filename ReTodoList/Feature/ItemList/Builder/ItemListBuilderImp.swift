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

    func build() -> UIView {
        let token = ""
        let router = NavToEditorRouterImp(
            navigationController: navigationController,
            editorBuilder: EditorBuilderImp(store: store)
        )

        weak var viewLazy: ItemListView?

        let logger = LoggerImpl(isLoggingEnabled: true)
        let persistentContainer = TodoListPersistentContainer(logger: logger)
        let service = TodoListServiceOne(
            isRemotingEnabled: !token.isEmpty,
            cache: TodoListCacheImp(container: persistentContainer, logger: logger),
            deadItemsCache: DeadItemsCacheImp(container: persistentContainer, logger: logger),
            networking: DefaultNetworkingService(
                urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
                headers: [
                    "Authorization": token,
                    "Content-Type": "application/json"
                ],
                coreService: URLSessionCoreService(),
                coder: JSONTodoCoder()
            ),
            dispatch: { action in
                self.store.dispatch(action)
            }
        )

        let model = ItemListModelImp(
            viewBlock: { viewLazy },
            store: store,
            service: service
        )
        let view = ItemListViewImp(
            model: model,
            navToEditorRouter: router
        )

        viewLazy = view

        model.load()

        return view
    }
}
