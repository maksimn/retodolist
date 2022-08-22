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

final class VisibilitySwitchViewImp: UIView, VisibilitySwitchView {

    private let params: VisibilitySwitchViewParams
    private let model: VisibilitySwitchModel

    private let toggle = UIButton()

    init(params: VisibilitySwitchViewParams,
         model: VisibilitySwitchModel) {
        self.params = params
        self.model = model
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(state: ItemListState) {
        toggle.setTitle(state.areCompleteItemsVisible ? params.hide : params.show, for: .normal)
        toggle.setTitleColor(state.completedItemCount == 0 ? .systemGray : .systemBlue, for: .normal)
        toggle.isEnabled = state.completedItemCount > 0
    }

    @objc
    private func onToggleTap() {
        model.switchCompletedItemsVisibility()
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
