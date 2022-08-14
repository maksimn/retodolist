//
//  ItemListThunkImp+DI.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.08.2022.
//

extension ItemListThunkImp {

    convenience init() {
        let logger = LoggerImpl(isLoggingEnabled: true)
        let persistentContainer = TodoListPersistentContainer(logger: logger)
        let cache = TodoListCacheImp(container: persistentContainer, logger: logger)
        let deadItemsCache = DeadItemsCacheImp(container: persistentContainer, logger: logger)
        let service = TodoListServiceImp()

        self.init(cache: cache, deadItemsCache: deadItemsCache, service: service)
    }
}
