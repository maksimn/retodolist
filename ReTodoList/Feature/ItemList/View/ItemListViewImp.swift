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
    private let newItemCellPlaceholderText: String

    private let tableView = UITableView()
    private lazy var tableController = ItemsTableController(
        tableView: tableView,
        newItemCellPlaceholderText: newItemCellPlaceholderText,
        onNewTodoItemTextEnter: { [weak self] text in
            self?.onNewTodoItemTextEnter(text)
        },
        onDeleteTap: { [weak self] position in
            self?.onDeleteTap(position)
        },
        onTodoCompletionTap: { [weak self] position in
            self?.onTodoCompletionTap(position)
        },
        onDidSelectAt: { [weak self] position in
            self?.onDidSelectAt(position)
        }
    )

    init(model: ItemListModel,
         navToEditorRouter: NavToEditorRouter,
         newItemCellPlaceholderText: String) {
        self.model = model
        self.navToEditorRouter = navToEditorRouter
        self.newItemCellPlaceholderText = newItemCellPlaceholderText
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

    private func onNewTodoItemTextEnter(_ text: String) {
        model.create(item: TodoItem(text: text))
    }

    private func onDeleteTap(_ position: Int) {
        if let item = itemAt(position) {
            model.delete(item: item)
        }
    }

    private func onTodoCompletionTap(_ position: Int) {
        if let item = itemAt(position) {
            model.toggleCompletionFor(item: item)
        }
    }

    private func onDidSelectAt(_ position: Int) {
        if let item = itemAt(position) {
            navToEditorRouter.navigate(with: item)
        }
    }

    private func itemAt(_ position: Int) -> TodoItem? {
        guard position > -1 && position < tableController.items.count else { return nil }

        return tableController.items[position]
    }

    private func initViews() {
        view.addSubview(tableView)
        tableView.backgroundColor = Theme.data.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view)
        }
        tableView.keyboardDismissMode = .onDrag
    }
}
