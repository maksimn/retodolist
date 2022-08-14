//
//  TodoListServiceImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Foundation

final class TodoListServiceImp: TodoListService {

    func getItems(_ completion: @escaping (Result<[TodoItem], Error>) -> Void) {

    }

    func createRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {

    }

    func updateRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {

    }

    func deleteRemote(_ item: TodoItem, _ completion: @escaping (Result<Void, Error>) -> Void) {

    }

    func mergeWithRemote(_ deleted: [String], _ other: [TodoItem],
                         _ completion: @escaping (Result<[TodoItem], Error>) -> Void) {

    }
}
