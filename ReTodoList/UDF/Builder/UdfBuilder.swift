//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import ReSwiftRouter

protocol UdfBuilder {

    func build() -> Router<AppState>
}
