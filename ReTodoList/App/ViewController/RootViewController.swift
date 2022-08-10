//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class RootViewController: UIViewController {

    let navToEditorButton = UIButton()

    init() {
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func onNavToEditorButtonTap() { }
}
