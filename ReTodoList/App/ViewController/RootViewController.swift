//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class RootViewController: UIViewController {

    let navToEditorButton = UIButton()

    let networkIndicatorGraph: NetworkIndicatorGraph

    init(mainTitle: String,
         counterBuilder: CounterBuilder,
         visibilitySwitchBuilder: VisibilitySwitchBuilder,
         itemListBuilder: ItemListBuilder,
         navToEditorBuilder: NavToEditorBuilder,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        networkIndicatorGraph = networkIndicatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mainTitle
        view.backgroundColor = Theme.data.backgroundColor
        layout(counterBuilder)
        layout(visibilitySwitchBuilder)
        layout(itemListBuilder)
        layout(navToEditorBuilder)
        layout(networkIndicatorGraph.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
