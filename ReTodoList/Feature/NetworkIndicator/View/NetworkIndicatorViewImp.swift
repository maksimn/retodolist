//
//  NetworkIndicatorView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import SnapKit
import UIKit

final class NetworkIndicatorViewImp: UIView, NetworkIndicatorView {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let model: NetworkIndicatorModel

    init(model: NetworkIndicatorModel) {
        self.model = model
        super.init(frame: .zero)
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(visible: Bool) {
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
