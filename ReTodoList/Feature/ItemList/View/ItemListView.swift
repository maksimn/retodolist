//
//  ItemListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import ReSwift
import UIKit

final class ItemListView: UIView, StoreSubscriber {

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

    private let store: Store<AppState>

    init(store: Store<AppState>,
         navToEditorRouter: NavToEditorRouter) {
        self.store = store
        self.navToEditorRouter = navToEditorRouter
        super.init(frame: .zero)
        initViews()
        store.subscribe(self) { subcription in
            subcription.select { state in state.itemListState }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func newState(state: ItemListState?) {
        guard let state = state else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()
        var items = state.areCompleteItemsVisible ? state.items : state.items.filter { !$0.isCompleted }

        tableController.items = items
        items.append(TodoItem(isTerminal: true))
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)

        datasource.apply(snapshot)
    }

    func onNewTodoItemTextEnter(_ text: String) {
        store.dispatch(CreateItemAction(item: TodoItem(text: text)))
    }

    func onDeleteTap(_ position: Int) {
        guard position > -1 && position < tableController.items.count else { return }

        let todoItem = tableController.items[position]

        store.dispatch(DeleteItemAction(item: todoItem))
    }

    func onTodoCompletionTap(_ position: Int) {
        guard position > -1 && position < tableController.items.count else { return }

        let todoItem = tableController.items[position]

        store.dispatch(ToggleItemCompletionAction(item: todoItem))
    }

    func onDidSelectAt(_ position: Int) {
        guard position > -1 && position < tableController.items.count else { return }

        let todoItem = tableController.items[position]

        navToEditorRouter.navigate(with: todoItem)
    }
}
