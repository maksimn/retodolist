//
//  EditorModel.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

protocol EditorModel {

    func dispatch(_ action: Action)

    func unsubscribe()
}
