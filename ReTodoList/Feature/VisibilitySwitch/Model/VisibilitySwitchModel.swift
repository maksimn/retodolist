//
//  VisibilitySwitchModel.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

protocol VisibilitySwitchModel: UDFModel {

    func dispatch(_ action: Action)
}
