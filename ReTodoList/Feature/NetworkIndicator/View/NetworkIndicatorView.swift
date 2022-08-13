//
//  NetworkIndicatorView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift
import SnapKit
import UIKit

final class NetworkIndicatorView: UIView, StoreSubscriber {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    init(store: Store<AppState>) {
        super.init(frame: .zero)
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        store.subscribe(self) { subcription in
            subcription.select { state in state.networkIndicatorState }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func newState(state: NetworkIndicatorState?) {
        guard let state = state else { return }

        if state.pendingRequestCount > 0 {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
