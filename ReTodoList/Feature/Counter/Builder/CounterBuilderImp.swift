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
        weak var viewLazy: CounterView?

        let model = CounterModelImp(viewBlock: { viewLazy }, store: store)
        let view = CounterViewImp(text: "Выполнено — ", model: model)

        viewLazy = view

        return view
    }
}
