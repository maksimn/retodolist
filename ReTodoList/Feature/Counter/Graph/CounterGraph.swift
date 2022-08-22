//
//  CounterGraph.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 22.08.2022.
//

import UIKit

protocol CounterGraph {

    var view: UIView { get }

    var model: UDFModel? { get }
}
