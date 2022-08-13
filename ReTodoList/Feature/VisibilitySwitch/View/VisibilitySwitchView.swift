//
//  VisibilitySwitchView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift
import UIKit

struct VisibilitySwitchViewParams {
    let show: String
    let hide: String
}

final class VisibilitySwitchView: UIView, StoreSubscriber {

    private let params: VisibilitySwitchViewParams
    private let store: Store<AppState>

    let toggle = UIButton()

    init(params: VisibilitySwitchViewParams,
         store: Store<AppState>) {
        self.params = params
        self.store = store
        super.init(frame: .zero)
        initViews()
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        toggle.setTitle(state.areCompleteItemsVisible ? params.hide : params.show, for: .normal)
        toggle.setTitleColor(state.completedItemCount == 0 ? .systemGray : .systemBlue, for: .normal)
        toggle.isEnabled = state.completedItemCount > 0
    }

    @objc
    func onToggleTap() {
        store.dispatch(SwitchCompletedItemsVisibilityAction())
    }

    private func initViews() {
        addSubview(toggle)
        toggle.addTarget(self, action: #selector(onToggleTap), for: .touchUpInside)
        toggle.backgroundColor = .clear
        toggle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        toggle.setTitle(params.show, for: .normal)
        toggle.setTitleColor(.systemGray, for: .normal)
        toggle.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
