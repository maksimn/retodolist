//
//  NewTodoItemCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 19.06.2021.
//

import SnapKit
import UIKit

extension NewTodoItemCell {

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
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 18, bottom: 16, right: 20)
        textView.contentOffset = CGPoint(x: 0, y: -6)
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(16)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-14)
            make.height.equalTo(24)
        }
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 16
        textView.isEditable = true
    }

    private func initPlacholderLabel() {
        placeholderLabel.textColor = .gray
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = "Новое"
        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(17)
            make.left.equalTo(self.contentView.snp.left).offset(40)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.height.equalTo(24)
        }
        placeholderLabel.isUserInteractionEnabled = false
    }
}
