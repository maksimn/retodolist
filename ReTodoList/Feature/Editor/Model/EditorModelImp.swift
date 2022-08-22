//
//  EditorModelImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation
import ReSwift

final class EditorModelImp: EditorModel, StoreSubscriber {

    private let viewBlock: () -> EditorView?
    private weak var view: EditorView?
    private let store: Store<AppState>
    private let thunk: CUDTodoItemThunk

    init(viewBlock: @escaping () -> EditorView?,
         store: Store<AppState>,
         thunk: CUDTodoItemThunk) {
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

    func setInitial(item: TodoItem?) {
        store.dispatch(InitEditorAction(item: item))
    }

    func set(deadline: Date?) {
        store.dispatch(DeadlineChangedEditorAction(deadline: deadline))
    }

    func set(isDeadlinePickerHidden: Bool) {
        store.dispatch(DeadlinePickerVisibilityAction(isHidden: isDeadlinePickerHidden))
    }

    func set(text: String) {
        store.dispatch(TextChangedEditorAction(text: text))
    }

    func set(priority: TodoItemPriority) {
        store.dispatch(PriorityChangedEditorAction(priority: priority))
    }

    func save() {
        let isCreatingMode = store.state.editorState?.mode == .creating
        let item = store.state.editorState?.item

        store.dispatch(EditorItemSavedAction())

        if isCreatingMode, let item = item {
            store.dispatch(thunk.createInCacheAndRemote(item))
        } else if let item = item {
            store.dispatch(thunk.updateInCacheAndRemote(item))
        }
    }

    func delete() {
        guard let item = store.state.editorState?.item else { return }

        store.dispatch(EditorItemDeletedAction())
        store.dispatch(thunk.deleteInCacheAndRemote(item))
    }

    func close() {
        store.dispatch(CloseEditorAction())
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
