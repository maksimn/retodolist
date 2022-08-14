//
//  TodoListServiceOne+DI.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

extension TodoListServiceOne {

    convenience init(store: Store<AppState>) {
        let token = ""

        let logger = LoggerImpl(isLoggingEnabled: true)
        let persistentContainer = TodoListPersistentContainer(logger: logger)

        self.init(
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
                store.dispatch(action)
            }
        )
    }
}
