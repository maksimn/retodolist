//
//  TodoListDataSource.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

final class ItemsTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    private(set) var items: [TodoItem] = []

    var onNewTodoItemTextEnter: ((String) -> Void)?
    var onDeleteTap: ((Int) -> Void)?
    var onTodoCompletionTap: ((Int) -> Void)?
    var onDidSelectAt: ((Int) -> Void)?

    private weak var tableView: UITableView?

    init(tableView: UITableView) {
        self.tableView = tableView
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

            cell.onNewTodoItemTextEnter = self.onNewTodoItemTextEnter

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

            onDidSelectAt?(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: "",
                                             handler: { (_, _, success: (Bool) -> Void) in
                                                self.onTodoCompletionTap?(indexPath.row)
                                                success(true)
                                             })
        completionAction.image = Theme.image.completedTodoMarkInverse
        completionAction.backgroundColor = Theme.data.darkGreen

        return UISwipeActionsConfiguration(actions: [completionAction])
     }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = Theme.image.trashImage
        deleteAction.backgroundColor = Theme.data.darkRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
     }
}
