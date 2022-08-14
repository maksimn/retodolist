//
//  VisibilitySwitchBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift
import UIKit

final class VisibilitySwitchBuilderImp: VisibilitySwitchBuilder {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build() -> UIView {
        weak var viewLazy: VisibilitySwitchView?

        let model = VisibilitySwitchModelImp(viewBlock: { viewLazy }, store: store)
        let view = VisibilitySwitchViewImp(
            params: VisibilitySwitchViewParams(
                show: "Показать",
                hide: "Скрыть"
            ),
            model: model
        )

        viewLazy = view

        model.subscribe()

        return view
    }
}
