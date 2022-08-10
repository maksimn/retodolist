//
//  RootViewController+Layout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import UIKit

extension RootViewController {

    func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        layoutNavToEditorButton()
    }

    private func layoutNavToEditorButton() {
        view.addSubview(navToEditorButton)
        navToEditorButton.setImage(Theme.image.plusImage, for: .normal)
        navToEditorButton.imageView?.contentMode = .scaleAspectFit
        navToEditorButton.translatesAutoresizingMaskIntoConstraints = false
        navToEditorButton.addTarget(self, action: #selector(onNavToEditorButtonTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            navToEditorButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            navToEditorButton.heightAnchor.constraint(equalToConstant: 44),
            navToEditorButton.widthAnchor.constraint(equalToConstant: 44),
            navToEditorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        if let imageView = navToEditorButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: navToEditorButton.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: navToEditorButton.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: navToEditorButton.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: navToEditorButton.bottomAnchor)
            ])
        }
    }
}
