//
//  appReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import ReSwiftRouter

func appReducer(action: Action, state: AppState?) -> AppState {
    AppState(
        navigationState: NavigationReducer.handleAction(action, state: state?.navigationState)
    )
}
