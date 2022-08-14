//
//  EditorModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import ReSwift

final class EditorModelImp: EditorModel, StoreSubscriber {

    private let viewBlock: () -> EditorView?
    private weak var view: EditorView?
    private let store: Store<AppState>

    init(viewBlock: @escaping () -> EditorView?,
         store: Store<AppState>) {
        self.viewBlock = viewBlock
        self.store = store
    }

    func subscribe() {
        if view == nil {
            view = viewBlock()
        }

        store.subscribe(self) { subcription in
            subcription.select { state in state.editorState }
        }
    }

    func newState(state: EditorState?) {
        guard let state = state else { return }

        view?.set(state: state)
    }

    func dispatch(_ action: Action) {
        store.dispatch(action)

        if action as? EditorItemSavedAction != nil {

        } else if action as? EditorItemDeletedAction != nil {

        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
