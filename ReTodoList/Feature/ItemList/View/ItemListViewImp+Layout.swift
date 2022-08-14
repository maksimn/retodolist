//
//  ItemListView+Layout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import UIKit

extension ItemListViewImp {

    func initViews() {
        addSubview(tableView)
        tableView.backgroundColor = Theme.data.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = datasource
        tableView.backgroundColor = Theme.data.backgroundColor
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        tableView.keyboardDismissMode = .onDrag
        tableController.onDeleteTap = self.onDeleteTap
        tableController.onTodoCompletionTap = self.onTodoCompletionTap
        tableController.onDidSelectAt = self.onDidSelectAt
    }
}
