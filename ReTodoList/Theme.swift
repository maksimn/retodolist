//
//  Theme.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

struct Theme {

    let backgroundColor: UIColor

    let lightTextColor: UIColor

    let darkRed: UIColor

    let darkGreen: UIColor

    private init(backgroundColor: UIColor,
                 lightTextColor: UIColor,
                 darkRed: UIColor,
                 darkGreen: UIColor) {
        self.backgroundColor = backgroundColor
        self.lightTextColor = lightTextColor
        self.darkRed = darkRed
        self.darkGreen = darkGreen
    }

    static let data = Theme(
        backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
        lightTextColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3),
        darkRed: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1),
        darkGreen: UIColor(red: 0.196, green: 0.843, blue: 0.294, alpha: 1)
    )

    static let image = ThemeImage()
}

final class ThemeImage {

    lazy var plusImage = UIImage(named: "icon-plus")!
    lazy var highPriorityMark = UIImage(named: "high-priority")!
    lazy var lowPriorityMark = UIImage(named: "low-priority")!

    lazy var completedTodoMark = UIImage(named: "finished-todo")!
    lazy var completedTodoMarkInverse = UIImage(named: "finished-todo-inverse")!
    lazy var highPriorityTodoMark = UIImage(named: "high-priority-circle")!
    lazy var incompletedTodoMark = UIImage(named: "not-finished-todo")!

    lazy var rightArrowMark = UIImage(named: "right-arrow")!

    lazy var smallCalendarIcon = UIImage(named: "small-calendar")!

    lazy var trashImage = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
}
