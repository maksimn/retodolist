//
//  CounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import ReSwift

final class CounterBuilderImp: CounterBuilder {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build() -> UDFGraph {
        CounterGraphImp(store: store)
    }
}
