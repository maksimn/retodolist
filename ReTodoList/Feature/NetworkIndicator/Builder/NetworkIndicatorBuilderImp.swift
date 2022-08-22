//
//  NetworkIndicatorBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

final class NetworkIndicatorBuilderImp: NetworkIndicatorBuilder {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build() -> UDFGraph {
        NetworkIndicatorGraphImp(store: store)
    }
}
