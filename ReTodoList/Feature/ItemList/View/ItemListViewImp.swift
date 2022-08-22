//
//  ItemListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class ItemListViewImp: UIViewController, ItemListView {

    private let model: ItemListModel
    private let navToEditorRouter: NavToEditorRouter

    let tableView = UITableView()
    lazy var tableController = ItemsTableController(tableView: tableView)

    init(model: ItemListModel,
         navToEditorRouter: NavToEditorRouter) {
        self.model = model
        self.navToEditorRouter = navToEditorRouter
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.unsubscribe()
    }

    func set(state: ItemListState) {
        let items = state.areCompleteItemsVisible ? state.items : state.items.filter { !$0.isCompleted }

        tableController.update(items)
    }

    func onNewTodoItemTextEnter(_ text: String) {
        model.create(item: TodoItem(text: text))
    }

    func onDeleteTap(_ position: Int) {
        if let item = itemAt(position) {
            model.delete(item: item)
        }
    }

    func onTodoCompletionTap(_ position: Int) {
        if let item = itemAt(position) {
            model.toggleCompletionFor(item: item)
        }
    }

    func onDidSelectAt(_ position: Int) {
        if let item = itemAt(position) {
            navToEditorRouter.navigate(with: item)
        }
    }

    private func itemAt(_ position: Int) -> TodoItem? {
        guard position > -1 && position < tableController.items.count else { return nil }

        return tableController.items[position]
    }
}
