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
    private let thunk: ItemListThunk

    init(viewBlock: @escaping () -> EditorView?,
         store: Store<AppState>,
         thunk: ItemListThunk) {
        self.viewBlock = viewBlock
        self.store = store
        self.thunk = thunk
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
        let isCreatingMode = store.state.editorState?.mode == .creating
        let item = store.state.editorState?.item

        store.dispatch(action)

        if action as? EditorItemSavedAction != nil {
            if isCreatingMode, let item = item {
                store.dispatch(thunk.createItemInCacheAndRemote(item))
            } else if let item = item {
                store.dispatch(thunk.updateItemInCacheAndRemote(item))
            }
        } else if action as? EditorItemDeletedAction != nil, let item = item {
            store.dispatch(thunk.deleteItemInCacheAndRemote(item))
        }
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
