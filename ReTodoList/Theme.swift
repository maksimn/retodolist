//
//  Theme.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

struct Theme {

    let backgroundColor: UIColor

    private init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }

    static let data = Theme(
        backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
    )

    static let image = ThemeImage()
}

final class ThemeImage {

    lazy var plusImage = UIImage(named: "icon-plus")!
}
