//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ReSwift
import ReSwiftRouter
import UIKit

final class RootViewController: UIViewController {

    let navToEditorButton = UIButton()

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func onNavToEditorButtonTap() {
        store.dispatch(SetRouteAction(["Root", "Editor"]))
    }
}
