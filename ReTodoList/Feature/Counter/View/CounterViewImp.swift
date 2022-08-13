//
//  CounterView.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CounterViewImp: UIView, CounterView {

    private let text: String

    private let model: CounterModel

    private let label = UILabel()

    init(text: String,
         model: CounterModel) {
        self.text = text
        self.model = model
        super.init(frame: .zero)
        initLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(count: Int) {
        label.text = text + String(count)
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
