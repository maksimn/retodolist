//
//  NavigationEffect.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 08.09.2022.
//

import ReSwiftThunk

protocol NavigationEffect {

    func showEditor(item: TodoItem?) -> Thunk<AppState>

    func hideEditor() -> Thunk<AppState>
}
