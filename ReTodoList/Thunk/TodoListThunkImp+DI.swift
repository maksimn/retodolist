//
//  ItemListThunkImp+DI.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.08.2022.
//

import Foundation

extension TodoListThunkImp {

    convenience init() {
        let token = ""
        let logger = LoggerImpl(isLoggingEnabled: true)
        let persistentContainer = TodoListPersistentContainer(logger: logger)
        let cache = TodoListCacheImp(container: persistentContainer, logger: logger)
        let deadItemsCache = DeadItemsCacheImp(container: persistentContainer, logger: logger)
        let service = TodoListServiceImp(
            networking: NetworkingServiceImp(
                urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
                headers: [
                    "Authorization": token,
                    "Content-Type": "application/json"
                ],
                httpClient: HttpClientImp(),
                coder: JsonCoderImp()
            )
        )

        self.init(cache: cache, deadItemsCache: deadItemsCache, service: service, userDefaults: UserDefaults.standard)
    }
}
