//
//  EditorThunk.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwiftThunk

func editorSaveRemoteItem(withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, getState in
        guard let state = getState(),
              let item = state.editorState?.item else {
            return
        }

        if state.editorState?.mode == .creating {
            service.createRemote(item) { _ in

            }
        } else {
            service.updateRemote(item) { _ in

            }
        }
    }
}

func editorDeleteRemoteItem(withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, getState in
        guard let state = getState(),
              let item = state.editorState?.item else {
            return
        }

        service.removeRemote(item) { _ in

        }
    }
}
