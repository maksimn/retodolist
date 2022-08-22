//
//  VisibilitySwitchBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

final class VisibilitySwitchBuilderImp: VisibilitySwitchBuilder {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build() -> UDFGraph {
        VisibilitySwitchGraphImp(store: store)
    }
}
