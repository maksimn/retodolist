//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class RootViewController: UIViewController {

    let navToEditorButton = UIButton()

    init(mainTitle: String,
         navToEditorBuilder: NavToEditorBuilder) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mainTitle
        view.backgroundColor = Theme.data.backgroundColor
        layout(navToEditorBuilder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
