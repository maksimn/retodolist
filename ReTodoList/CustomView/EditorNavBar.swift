//
//  EditorNavBar.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

struct EditorNavBarParams {
    let save: String
    let todo: String
    let cancel: String
}

class EditorNavBar {

    var onSaveButtonTap: (() -> Void)?
    var onCancelButtonTap: (() -> Void)?

    private let params: EditorNavBarParams
    private lazy var saveBarButtonItem = UIBarButtonItem(title: params.save, style: .plain,
                                                         target: self, action: #selector(saveButtonTap))

    init(params: EditorNavBarParams,
         navigationItem: UINavigationItem,
         networkIndicatorView: UIView) {
        self.params = params
        let activityBarButtonItem = UIBarButtonItem(customView: networkIndicatorView)

        navigationItem.title = params.todo
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItems = [saveBarButtonItem, activityBarButtonItem]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: params.cancel, style: .plain,
                                                           target: self, action: #selector(cancelButtonTap))
    }

    @objc private func saveButtonTap() {
        onSaveButtonTap?()
    }

    @objc private func cancelButtonTap() {
        onCancelButtonTap?()
    }

    func setSaveButton(_ enabled: Bool) {
        saveBarButtonItem.isEnabled = enabled
    }
}
