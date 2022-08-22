//
//  VisibilitySwitchGraphImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 22.08.2022.
//

import ReSwift
import UIKit

final class VisibilitySwitchGraphImp: VisibilitySwitchGraph {

    let view: UIView

    private(set) weak var model: UDFModel?

    init(store: Store<AppState>) {
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

        self.view = view
        self.model = model
    }
}
