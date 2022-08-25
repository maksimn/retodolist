//
//  TodoListThunkFlagsImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 25.08.2022.
//

import Foundation

private let getItemsCompletedKey = "io.github.maksimn.retodolist.getItemsCompletedKey"

final class TodoListThunkFlagsImp: TodoListThunkFlags {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var isGetRemotedItemsCompleted: Bool {
        get {
            userDefaults.bool(forKey: getItemsCompletedKey)
        }
        set {
            userDefaults.set(newValue, forKey: getItemsCompletedKey)
        }
    }
}
