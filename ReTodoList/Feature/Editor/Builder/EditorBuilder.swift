//
//  EditorBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

protocol EditorBuilder {

    func build(initTodoItem: TodoItem?) -> UIViewController
}
