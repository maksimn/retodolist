//
//  TodoListDataSource.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

final class ItemsTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    private(set) var items: [TodoItem] = []

    private weak var tableView: UITableView?
    private let newItemCellPlaceholderText: String
    private var onNewTodoItemTextEnter: (String) -> Void
    private var onDeleteTap: (Int) -> Void
    private var onTodoCompletionTap: (Int) -> Void
    private var onDidSelectAt: (Int) -> Void

    init(tableView: UITableView,
         newItemCellPlaceholderText: String,
         onNewTodoItemTextEnter: @escaping (String) -> Void,
         onDeleteTap: @escaping (Int) -> Void,
         onTodoCompletionTap: @escaping (Int) -> Void,
         onDidSelectAt: @escaping (Int) -> Void) {
        self.tableView = tableView
        self.newItemCellPlaceholderText = newItemCellPlaceholderText
        self.onNewTodoItemTextEnter = onNewTodoItemTextEnter
        self.onDeleteTap = onDeleteTap
        self.onTodoCompletionTap = onTodoCompletionTap
        self.onDidSelectAt = onDidSelectAt
    }

    func update(_ items: [TodoItem]) {
        let prev = self.items

        self.items = items

        if Array.isCreateItemOperation(items, prev) {
            tableView?.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        } else if Array.isUpdateItemOperation(items, prev) {
            for i in 0..<items.count where prev[i] != items[i] {
                tableView?.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
        } else if Array.isDeleteItemOperation(items, prev) {
            for i in 0..<prev.count {
                if (i < prev.count - 1 && prev[i] != items[i]) || i == prev.count - 1 {
                    tableView?.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                    break
                }
            }
        } else if Array.isExpandCompletedItemsOperation(items, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = items.completedTodoItemIndexPaths
                self.tableView?.insertRows(at: indexPaths, with: .automatic)

                if let firstIndexPath = indexPaths.first {
                    let indexPaths = self.tableView?.indexPathsForVisibleRows?
                        .filter { $0.row >= firstIndexPath.row } ?? []
                    self.tableView?.reloadRows(at: indexPaths, with: .automatic)
                }
            }, completion: nil)
        } else if Array.isCollapseCompletedItemsOperation(items, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = prev.completedTodoItemIndexPaths
                self.tableView?.deleteRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        } else {
            tableView?.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewTodoItemCell.self)",
                                                           for: indexPath) as? NewTodoItemCell else {
                return UITableViewCell()
            }

            cell.set(placeholderText: newItemCellPlaceholderText, onTextEntered: onNewTodoItemTextEnter)

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoItemCell.self)",
                                                       for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }
        let todoItem = items[indexPath.row]

        cell.set(todoItem: todoItem)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < items.count {
            if items[indexPath.row].isCompleted {
                return
            }

            onDidSelectAt(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: "",
                                             handler: { [weak self] (_, _, success: (Bool) -> Void) in
                                                self?.onTodoCompletionTap(indexPath.row)
                                                success(true)
                                             })
        completionAction.image = Theme.image.completedTodoMarkInverse
        completionAction.backgroundColor = Theme.data.darkGreen

        return UISwipeActionsConfiguration(actions: [completionAction])
     }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { [weak self] (_, _, success: (Bool) -> Void) in
                                                self?.onDeleteTap(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = Theme.image.trashImage
        deleteAction.backgroundColor = Theme.data.darkRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
     }
}
