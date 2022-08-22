//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class RootViewController: UIViewController {

    let navToEditorButton = UIButton()
    let counterGraph: CounterGraph
    let visibilitySwitchGraph: VisibilitySwitchGraph
    let networkIndicatorGraph: NetworkIndicatorGraph

    init(mainTitle: String,
         counterBuilder: CounterBuilder,
         visibilitySwitchBuilder: VisibilitySwitchBuilder,
         itemListBuilder: ItemListBuilder,
         navToEditorBuilder: NavToEditorBuilder,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        counterGraph = counterBuilder.build()
        visibilitySwitchGraph = visibilitySwitchBuilder.build()
        networkIndicatorGraph = networkIndicatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mainTitle
        view.backgroundColor = Theme.data.backgroundColor
        layoutCounter()
        layoutVisibilitySwitch()
        layout(itemListBuilder: itemListBuilder)
        layout(navToEditorBuilder: navToEditorBuilder)
        layoutNetworkIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }

    private func subscribe() {
        counterGraph.model?.subscribe()
        visibilitySwitchGraph.model?.subscribe()
        networkIndicatorGraph.model?.subscribe()
    }

    private func unsubscribe() {
        counterGraph.model?.unsubscribe()
        visibilitySwitchGraph.model?.unsubscribe()
        networkIndicatorGraph.model?.unsubscribe()
    }
}
