//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

final class AppViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
