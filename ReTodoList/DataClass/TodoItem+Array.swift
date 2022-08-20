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

    static func isCreateItemOperation(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.count + 1 == items.count && Array(items.prefix(prev.count)) == prev
    }

    static func isUpdateItemOperation(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.count == items.count
    }

    static func isDeleteItemOperation(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        if prev.count == items.count + 1 {
            var i = 0, j = 0, counter = 0

            while i < items.count {
                if items[i] == prev[j] {
                    i += 1
                    j += 1
                } else {
                    j += 1
                    counter += 1

                    if counter > 1 {
                        return false
                    }
                }
            }

            if counter == 1 {
                return true
            }
        }

        return false
    }

    static func isExpandCompletedItemsOperation(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.allSatisfy({ !$0.isCompleted }) && items.contains(where: { $0.isCompleted })
    }

    static func isCollapseCompletedItemsOperation(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        items.allSatisfy({ !$0.isCompleted }) && prev.contains(where: { $0.isCompleted })
    }
}
