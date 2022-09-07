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
    private let initialItem: TodoItem?
    private let store: Store<AppState>
    private let effect: CUDTodoItemEffect

    init(viewBlock: @escaping () -> EditorView?,
         initialItem: TodoItem?,
         store: Store<AppState>,
         effect: CUDTodoItemEffect) {
        self.viewBlock = viewBlock
        self.initialItem = initialItem
        self.store = store
        self.effect = effect
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

    func initialize() {
        store.dispatch(InitEditorAction(item: initialItem))
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
            store.dispatch(effect.createInCacheAndRemote(item))
        } else if let item = item {
            store.dispatch(effect.updateInCacheAndRemote(item))
        }
    }

    func delete() {
        guard let item = store.state.editorState?.item else { return }

        store.dispatch(EditorItemDeletedAction())
        store.dispatch(effect.deleteInCacheAndRemote(item))
    }

    func close() {
        store.dispatch(CloseEditorAction())
    }

    func unsubscribe() {
        store.unsubscribe(self)
    }
}
