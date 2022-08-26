//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

typealias TodoListDTOResult = Result<[TodoItemDTO], Error>
typealias TodoItemDTOResult = Result<TodoItemDTO, Error>

protocol TodoListNetworking {

    func fetchTodoList(_ completion: @escaping (TodoListDTOResult) -> Void)

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemDTOResult) -> Void)

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemDTOResult) -> Void)

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemDTOResult) -> Void)

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListDTOResult) -> Void)
}
