//
//  CounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import ReSwift
import UIKit

final class CounterBuilderImp: CounterBuilder {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build() -> UIView {
        CounterView(text: "Выполнено — ", store: store)
    }
}
