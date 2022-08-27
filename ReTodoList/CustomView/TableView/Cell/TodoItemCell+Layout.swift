//
//  TodoItemCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

extension TodoItemCell {

    static var fulfillmentMarginLeft: CGFloat { 16 }
    static var fulfillmentWidth: CGFloat { 24 }
    static var textMarginLeft: CGFloat { 12 }
    static var textMarginRight: CGFloat { 35 }
    static var priorityImageWidth: CGFloat { 10 }
    static var priorityImageMargin: CGFloat { 16 }
    static var deadlineHeight: CGFloat { 18.5 }

    func initViews() {
        selectionStyle = .none
        backgroundColor = .white
        textlabel.textColor = .black
        textlabel.font = Theme.data.normalFont
        textlabel.backgroundColor = .clear
        textlabel.numberOfLines = 3
        contentView.addSubview(textlabel)

        contentView.addSubview(leadingImageView)
        contentView.addSubview(priorityImageView)

        trailingImageView.image = Theme.image.rightArrowMark
        contentView.addSubview(trailingImageView)

        smallCalendarImageView.image = Theme.image.smallCalendarIcon
        contentView.addSubview(smallCalendarImageView)

        deadlineLabel.textColor = Theme.data.lightTextColor
        deadlineLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(deadlineLabel)
        setLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let priorityImageWidth: CGFloat = todoItem?.priority == .normal ? 0 : TodoItemCell.priorityImageMargin
        let textLabelLeftMargin = TodoItemCell.fulfillmentMarginLeft + TodoItemCell.fulfillmentWidth +
            priorityImageWidth + TodoItemCell.textMarginLeft + 2.5

        textlabel.preferredMaxLayoutWidth = frame.width - (textLabelLeftMargin + TodoItemCell.textMarginRight)
        textlabel.frame = CGRect(origin: CGPoint(x: textLabelLeftMargin, y: 17),
                                 size: textlabel.intrinsicContentSize)
    }

    var computedHeight: CGFloat {
        textlabel.frame.height + 34 + (todoItem?.deadline != nil ? TodoItemCell.deadlineHeight : 0)
    }

    private func setLayout() {
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                           constant: TodoItemCell.fulfillmentMarginLeft),
            leadingImageView.heightAnchor.constraint(equalToConstant: 24),
            leadingImageView.widthAnchor.constraint(equalToConstant: TodoItemCell.fulfillmentWidth)
        ])

        priorityImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priorityImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            priorityImageView.heightAnchor.constraint(equalToConstant: 16),
            priorityImageView.widthAnchor.constraint(equalToConstant: TodoItemCell.priorityImageWidth),
            priorityImageView.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 12)
        ])

        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trailingImageView.heightAnchor.constraint(equalToConstant: 12),
            trailingImageView.widthAnchor.constraint(equalToConstant: 7)
        ])

        smallCalendarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            smallCalendarImageView.leadingAnchor.constraint(equalTo: textlabel.leadingAnchor),
            smallCalendarImageView.widthAnchor.constraint(equalToConstant: 13),
            smallCalendarImageView.heightAnchor.constraint(equalToConstant: 12),
            smallCalendarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: smallCalendarImageView.trailingAnchor, constant: 5),
            deadlineLabel.topAnchor.constraint(equalTo: smallCalendarImageView.topAnchor, constant: -2.5),
            deadlineLabel.heightAnchor.constraint(equalToConstant: TodoItemCell.deadlineHeight)
        ])
    }
}
