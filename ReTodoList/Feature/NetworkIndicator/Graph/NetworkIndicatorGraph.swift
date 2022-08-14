//
//  NetworkIndicatorGraph.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import UIKit

protocol NetworkIndicatorGraph {

    var view: UIView { get }

    var model: NetworkIndicatorModel? { get }
}
