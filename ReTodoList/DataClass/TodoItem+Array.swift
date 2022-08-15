//
//  TodoItem+Array.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

extension Array where Element == TodoItem {

    var completedTodoItemIndexPaths: [IndexPath] {
        self.enumerated()
            .filter { $1.isCompleted }
            .map { IndexPath(row: $0.offset, section: 0) }
    }

    mutating func sortByCreateAt() {
        sort(by: { todo1, todo2 in
            todo1.createdAt < todo2.createdAt
        })
    }

    func mergeWith(_ remoteItems: [TodoItem]) -> [TodoItem] {
        var mergedItems: [TodoItem] = []

        // Добавлять TodoItem'ы с id, которых у вас нет
        for item in remoteItems where !self.contains(where: { $0.id == item.id }) {
            mergedItems.append(item)
        }

        // Удалять TodoItem'ы которые есть локально, но id  которых отсутствует в ответе ручки
        let itemsContainingInRemote = self.filter { item in
            remoteItems.contains(where: { $0.id == item.id })
        }

        // Обновлять TodoItem'ы, id  которых есть и у в кэше и в ответе ручки, и в поле updated_at ручки
        // бОльшее значение, чем у айтема в кэше
        for item in itemsContainingInRemote {
            if let remoteItem = remoteItems.first(where: { $0.id == item.id }),
                remoteItem.updatedAt > item.updatedAt {
                mergedItems.append(remoteItem)
            } else {
                mergedItems.append(item)
            }
        }

        mergedItems.sortByCreateAt()

        // для полученных моделей ставить флаг isDirty в значение false
        return mergedItems.map { $0.isDirty ? $0.update(isDirty: false) : $0 }
    }
}
