//
//  UDFGraph.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 22.08.2022.
//

import UIKit

protocol UDFGraph {

    var view: UIView { get }

    var model: UDFModel? { get }
}

protocol UDFGraphBuilder {

    func build() -> UDFGraph
}
