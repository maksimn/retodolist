//
//  EditorBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import UIKit

final class EditorBuilderImp: EditorBuilder {

    private var store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
    }

    func build(initTodoItem: TodoItem?) -> UIViewController {
        let viewParams = EditorViewParams(
            backgroundColor: Theme.data.backgroundColor,
            prioritySegmentedControlItems: [Theme.image.lowPriorityMark, "нет", Theme.image.highPriorityMark],
            newTodoPlaceholder: "Что надо сделать?",
            priority: "Важность",
            shouldBeDoneBefore: "Сделать до",
            remove: "Удалить",
            navBar: EditorNavBarParams(
                save: "Сохранить",
                todo: "Дело",
                cancel: "Отменить"
            )
        )

        store.dispatch(InitEditorAction(item: initTodoItem))

        return EditorViewController(
            params: viewParams,
            store: store
        )
    }
}
