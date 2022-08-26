//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

class TodoListNetworkingImp: TodoListNetworking {

    private let urlString: String
    private let headers: [String: String]
    private let httpClient: HttpClient
    private let coder: JsonCoder

    init(urlString: String,
         headers: [String: String],
         httpClient: HttpClient,
         coder: JsonCoder) {
        self.urlString = urlString
        self.headers = headers
        self.httpClient = httpClient
        self.coder = coder
    }

    func fetchTodoList(_ completion: @escaping (TodoListDTOResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            ),
            completion
        )
    }

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemDTOResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            todoItemDTO,
            completion
        )
    }

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemDTOResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(todoItemDTO.id)",
                method: "PUT",
                headers: headers
            ),
            todoItemDTO,
            completion
        )
    }

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemDTOResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            ),
            completion
        )
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListDTOResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            requestData,
            completion
        )
    }

    private func send<OutputDTO: Decodable>(_ http: Http, _ completion: @escaping (Result<OutputDTO, Error>) -> Void) {
        httpClient.send(http) { [weak self] result in
            self?.decode(result, completion)
        }
    }

    private func send<InputDTO: Encodable, OutputDTO: Decodable>(
        _ http: Http,
        _ dto: InputDTO,
        _ completion: @escaping (Result<OutputDTO, Error>) -> Void
    ) {
        coder.encode(dto) { [weak self] result in
            do {
                let data = try result.get()

                self?.httpClient.send(
                    Http(
                        urlString: http.urlString,
                        method: http.method,
                        headers: http.headers,
                        body: data
                    )
                ) { [weak self] result in
                    self?.decode(result, completion)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func decode<OutputDTO: Decodable>(_ result: Result<Data, Error>,
                                              _ completion: @escaping (Result<OutputDTO, Error>) -> Void) {
        do {
            let data = try result.get()

            coder.decode(data) { (result: Result<OutputDTO, Error>) in
                switch result {
                case .success(let dto):
                    completion(.success(dto))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
