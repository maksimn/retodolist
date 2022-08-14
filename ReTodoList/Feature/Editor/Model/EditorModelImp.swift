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
        store.subscribe(self) { subcription in
            subcription.select { state in state.editorState }
        }
    }

    func newState(state: EditorState?) {
        guard let state = state else { return }

        if view == nil {
            view = viewBlock()
        }

        view?.set(state: state)
    }

    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
