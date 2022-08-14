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

    if let action = action as? GetRemoteItemsAction {
        return newState(action, state)
    }

    if let action = action as? CreateRemoteItemAction {
        return newState(action, state)
    }

    if let action = action as? UpdateRemoteItemAction {
        return newState(action, state)
    }

    if let action = action as? DeleteRemoteItemAction {
        return newState(action, state)
    }

    if let action = action as? MergeWithRemoteItemsAction {
        return newState(action, state)
    }

    return state
}

private func newState(_ action: GetRemoteItemsAction, _ state: NetworkIndicatorState) -> NetworkIndicatorState {
    var newState = state

    switch action {
    case _ as GetRemoteItemsStartAction:
        newState.pendingRequestCount += 1
    case _ as GetRemoteItemsSuccessAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    case _ as GetRemoteItemsErrorAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func newState(_ action: CreateRemoteItemAction, _ state: NetworkIndicatorState) -> NetworkIndicatorState {
    var newState = state

    switch action {
    case _ as CreateRemoteItemStartAction:
        newState.pendingRequestCount += 1
    case _ as CreateRemoteItemSuccessAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    case _ as CreateRemoteItemErrorAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func newState(_ action: UpdateRemoteItemAction, _ state: NetworkIndicatorState) -> NetworkIndicatorState {
    var newState = state

    switch action {
    case _ as UpdateRemoteItemStartAction:
        newState.pendingRequestCount += 1
    case _ as UpdateRemoteItemSuccessAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    case _ as UpdateRemoteItemErrorAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func newState(_ action: DeleteRemoteItemAction, _ state: NetworkIndicatorState) -> NetworkIndicatorState {
    var newState = state

    switch action {
    case _ as DeleteRemoteItemStartAction:
        newState.pendingRequestCount += 1
    case _ as DeleteRemoteItemSuccessAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    case _ as DeleteRemoteItemErrorAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func newState(_ action: MergeWithRemoteItemsAction, _ state: NetworkIndicatorState) -> NetworkIndicatorState {
    var newState = state

    switch action {
    case _ as MergeWithRemoteItemsStartAction:
        newState.pendingRequestCount += 1
    case _ as MergeWithRemoteItemsSuccessAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    case _ as MergeWithRemoteItemsErrorAction:
        newState.pendingRequestCount = decrementIfPositive(state.pendingRequestCount)
    default:
        break
    }

    return newState
}

private func decrementIfPositive(_ count: Int) -> Int {
    return count > 0 ? count - 1 : 0
}
