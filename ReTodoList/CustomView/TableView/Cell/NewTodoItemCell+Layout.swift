//
//  NewTodoItemCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 19.06.2021.
//

import SnapKit
import UIKit

extension NewTodoItemCell {

    static let cellHeight: CGFloat = 54

    func initViews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        selectionStyle = .none
        backgroundColor = .white
        initPlacholderLabel()
        initTextView()
    }

    private func initTextView() {
        textView.delegate = self
        textView.font = Theme.data.normalFont
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 18, bottom: 16, right: 20)
        textView.contentOffset = CGPoint(x: 0, y: -6)
        addSubview(textView)
        textView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(16)
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right).offset(-16)
            make.height.equalTo(24)
        }
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 16
        textView.isEditable = true
    }

    private func initPlacholderLabel() {
        placeholderLabel.textColor = .gray
        placeholderLabel.font = Theme.data.normalFont
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = "Новое"
        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(17)
            make.left.equalTo(self.snp.left).offset(40)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(24)
        }
        placeholderLabel.isUserInteractionEnabled = false
    }
}
