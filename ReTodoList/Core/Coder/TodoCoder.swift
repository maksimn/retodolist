//
//  TodoCoder.swift
//  CoreTodo
//
//  Created by Maxim Ivanov on 13.07.2021.
//

import Foundation

protocol TodoCoder {

    func encodeAsync<T: Encodable>(_ requestData: T,
                                   _ completion: @escaping (Result<Data, Error>) -> Void)

    func decodeAsync<T: Decodable>(_ data: Data,
                                   _ completion: @escaping (Result<T, Error>) -> Void)
}
