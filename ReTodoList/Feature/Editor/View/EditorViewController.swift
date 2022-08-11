//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import ReSwiftRouter
import UIKit

final class EditorViewController: UIViewController {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .yellow

        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func buttonAction() {
        store.dispatch(SetRouteAction(["Root"]))

    }
}
