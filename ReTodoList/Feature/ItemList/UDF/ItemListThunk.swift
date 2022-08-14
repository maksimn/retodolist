//
//  Middleware.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwiftThunk

func getRemoteItems(withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, _ in
        service.fetchRemoteTodoList { _ in

        }
    }
}

func createRemoteItem(_ item: TodoItem, withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, _ in
        service.createRemote(item) { _ in

        }
    }
}

func updateRemoteItem(_ item: TodoItem, withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, _ in
        service.updateRemote(item) { _ in

        }
    }
}

func deleteRemoteItem(_ item: TodoItem, withService service: TodoListService) -> Thunk<AppState> {
    return Thunk<AppState> { _, _ in
        service.removeRemote(item) { _ in

        }
    }
}
