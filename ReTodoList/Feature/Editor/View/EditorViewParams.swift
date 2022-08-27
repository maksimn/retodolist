//
//  EditorViewParams.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

struct EditorViewParams {

    let backgroundColor: UIColor
    let prioritySegmentedControlItems: [Any]
    let newTodoPlaceholder: String
    let priority: String
    let shouldBeDoneBefore: String
    let remove: String
    let navBarStrings: EditorNavBarStrings
}

struct EditorNavBarStrings {
    let save: String
    let cancel: String
    let todo: String
}
