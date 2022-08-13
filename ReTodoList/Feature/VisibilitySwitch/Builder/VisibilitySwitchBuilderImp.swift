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
        return VisibilitySwitchView(
            params: VisibilitySwitchViewParams(
                show: "Показать",
                hide: "Скрыть"
            ),
            store: store
        )
    }
}