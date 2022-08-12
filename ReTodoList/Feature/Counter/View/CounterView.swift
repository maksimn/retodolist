//
//  CounterView.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import ReSwift
import UIKit

final class CounterView: UIView, StoreSubscriber {

    private let store: Store<AppState>

    private let label = UILabel()

    private let text: String

    init(text: String,
         store: Store<AppState>) {
        self.text = text
        self.store = store
        super.init(frame: .zero)
        initLabel()
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }

        label.text = text + String(state.completedItemCount)
    }

    private func initLabel() {
        addSubview(label)
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        label.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
