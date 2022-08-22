//
//  RootViewController+Layout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import SnapKit
import UIKit

extension RootViewController {

    func layoutCounter() {
        let counterView = counterGraph.view

        view.addSubview(counterView)
        counterView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(32)
            make.height.equalTo(20)
        }
    }

    func layoutVisibilitySwitch() {
        let visibilitySwitchView = visibilitySwitchGraph.view

        view.addSubview(visibilitySwitchView)
        visibilitySwitchView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-32)
            make.height.equalTo(20)
        }
    }

    func layout(itemListBuilder: ItemListBuilder) {
        let itemListViewController = itemListBuilder.build()
        let parentView = UIView()

        view.addSubview(parentView)
        parentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(view.snp.bottom)
        }

        parentView.addSubview(itemListViewController.view)
        addChild(itemListViewController)
        itemListViewController.didMove(toParent: self)
        itemListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(parentView)
        }
    }

    func layout(navToEditorBuilder: NavToEditorBuilder) {
        let navToEditorView = navToEditorBuilder.build()

        view.addSubview(navToEditorView)
        navToEditorView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalTo(view)
        }
    }

    func layoutNetworkIndicator() {
        let networkIndicatorView = networkIndicatorGraph.view

        view.addSubview(networkIndicatorView)
        networkIndicatorView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
