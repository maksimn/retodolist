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
    let navigationItem: UINavigationItem
    let networkIndicatorView: UIView
    let onSaveButtonTap: () -> Void
    let onCancelButtonTap: () -> Void
}

class EditorNavBar {

    private let params: EditorNavBarParams
    private lazy var saveBarButtonItem = UIBarButtonItem(title: params.save, style: .plain,
                                                         target: self, action: #selector(saveButtonTap))

    init(params: EditorNavBarParams) {
        self.params = params
        let activityBarButtonItem = UIBarButtonItem(customView: params.networkIndicatorView)

        params.navigationItem.title = params.todo
        params.navigationItem.setHidesBackButton(true, animated: false)
        params.navigationItem.rightBarButtonItems = [saveBarButtonItem, activityBarButtonItem]
        params.navigationItem.leftBarButtonItem = UIBarButtonItem(title: params.cancel, style: .plain,
                                                                  target: self, action: #selector(cancelButtonTap))
    }

    func setSaveButton(_ enabled: Bool) {
        saveBarButtonItem.isEnabled = enabled
    }

    @objc
    private func saveButtonTap() {
        params.onSaveButtonTap()
    }

    @objc
    private func cancelButtonTap() {
        params.onCancelButtonTap()
    }
}
