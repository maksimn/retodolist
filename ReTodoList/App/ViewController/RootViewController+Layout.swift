//
//  RootViewController+Layout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import SnapKit
import UIKit

extension RootViewController {

    func layout(_ itemListBuilder: ItemListBuilder) {
        let itemListView = itemListBuilder.build()

        view.addSubview(itemListView)
        itemListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

    func layout(_ navToEditorBuilder: NavToEditorBuilder) {
        let navToEditorView = navToEditorBuilder.build()

        view.addSubview(navToEditorView)
        navToEditorView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalTo(view)
        }
    }
}
