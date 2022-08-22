//
//  NetworkIndicatorGraphImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift
import UIKit

final class NetworkIndicatorGraphImp: UDFGraph {

    let view: UIView

    private(set) weak var model: UDFModel?

    init(store: Store<AppState>) {
        weak var viewLazy: NetworkIndicatorView?

        let model = NetworkIndicatorModelImp(viewBlock: { viewLazy }, store: store)
        let view = NetworkIndicatorViewImp(model: model)

        viewLazy = view

        model.subscribe()

        self.view = view
        self.model = model
    }
}
