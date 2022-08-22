//
//  CounterGraphImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 22.08.2022.
//

import ReSwift
import UIKit

final class CounterGraphImp: UDFGraph {

    let view: UIView

    private(set) weak var model: UDFModel?

    init(store: Store<AppState>) {
        weak var viewLazy: CounterView?

        let model = CounterModelImp(viewBlock: { viewLazy }, store: store)
        let view = CounterViewImp(text: "Выполнено — ", model: model)

        viewLazy = view

        self.view = view
        self.model = model
    }
}
