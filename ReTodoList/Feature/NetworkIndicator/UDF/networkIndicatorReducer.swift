//
//  networkIndicatorReducer.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ReSwift

func networkIndicatorReducer(action: Action, state: NetworkIndicatorState?) -> NetworkIndicatorState {
    guard let state = state else {
        return NetworkIndicatorState(pendingRequestCount: 0)
    }
    var newState = state

    switch action {
    case _ as IncrementNetworkRequestCountAction:
        newState.pendingRequestCount += 1
    case _ as DecrementNetworkRequestCountAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func decrementIfPositive(_ count: Int) -> Int {
    return count > 0 ? count - 1 : 0
}
