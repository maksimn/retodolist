//
//  EditorAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import Foundation
import ReSwift

enum EditorAction: Action {
    case initWith(item: TodoItem?)
    case close
    case textChanged(String)
    case priorityChanged(TodoItemPriority)
    case deadlineChanged(Date?)
    case toggleDeadlinePickerVisibility
    case itemSaved
    case itemDeleted
}
