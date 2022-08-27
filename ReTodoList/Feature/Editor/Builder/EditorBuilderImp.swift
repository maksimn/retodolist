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
            navBarStrings: EditorNavBarStrings(save: "Сохранить", cancel: "Отменить", todo: "Дело")
        )

        weak var viewLazy: EditorView?

        let model = EditorModelImp(
            viewBlock: { viewLazy },
            initialItem: initTodoItem,
            store: store,
            thunk: TodoListThunkImp()
        )
        let view = EditorViewController(
            params: viewParams,
            model: model,
            networkIndicatorBuilder: NetworkIndicatorBuilderImp(store: store)
        )

        viewLazy = view

        return view
    }
}
