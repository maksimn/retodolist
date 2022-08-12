//
//  appReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    AppState(
        itemListState: itemListReducer(action: action, state: state),
        editorState: editorReducer(action: action, state: state?.editorState)
    )
}
