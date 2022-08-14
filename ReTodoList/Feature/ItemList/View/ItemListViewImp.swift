//
//  ItemListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import ReSwift
import UIKit

final class ItemListViewImp: UIView, ItemListView {

    private let navToEditorRouter: NavToEditorRouter

    let tableView = UITableView()

    lazy var datasource = UITableViewDiffableDataSource<Int, TodoItem>(
        tableView: tableView
    ) { [weak self] tableView, indexPath, item in
        if item.isTerminal {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewTodoItemCell.self)",
                                                           for: indexPath) as? NewTodoItemCell else {
                return UITableViewCell()
            }
            cell.onNewTodoItemTextEnter = self?.onNewTodoItemTextEnter

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoItemCell.self)",
                                                       for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }

        cell.set(todoItem: item)

        return cell
    }

    let tableController = TodoTableController()

    private let model: ItemListModel

    init(model: ItemListModel,
         navToEditorRouter: NavToEditorRouter) {
        self.model = model
        self.navToEditorRouter = navToEditorRouter
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(state: ItemListState) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()
        var items = state.areCompleteItemsVisible ? state.items : state.items.filter { !$0.isCompleted }

        tableController.items = items
        items.append(TodoItem(isTerminal: true))
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)

        datasource.apply(snapshot)
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
