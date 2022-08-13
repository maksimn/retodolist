//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import UIKit

final class EditorViewController: UIViewController, UITextViewDelegate, StoreSubscriber {

    let params: EditorViewParams

    var navBar: EditorNavBar?
    let scrollView = UIScrollView(frame: .zero)
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let pillowView = UIView()
    let separatorViewOne = UIView()
    let separatorViewTwo = UIView()
    lazy var prioritySegmentedControl = UISegmentedControl(items: params.prioritySegmentedControlItems)
    let importanceLabel = UILabel()
    let shouldBeDoneBeforeLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let deadlineButton = UIButton()
    let deadlineDatePicker = UIDatePicker()
    let removeButton = UIButton()

    let keyboardEventsHandle = KeyboardEventsHandle()
    var isKeyboardActive: Bool = false
    var keyboardSize: CGSize = .zero

    private let store: Store<AppState>

    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(params: EditorViewParams,
         store: Store<AppState>,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.params = params
        self.store = store
        self.networkIndicatorBuilder = networkIndicatorBuilder
        super.init(nibName: nil, bundle: nil)
        initViews()
        store.subscribe(self) { subcription in
            subcription.select { state in state.editorState }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func newState(state: EditorState?) {
        guard let state = state else { return }

        navBar?.setSaveButton(state.canItemBeSaved)
        removeButton.isEnabled = state.canItemBeRemoved
        removeButton.setTitleColor(state.canItemBeRemoved ? .systemRed : .systemGray, for: .normal)
        deadlineDatePicker.isHidden = state.isDeadlinePickerHidden
        separatorViewTwo.isHidden = state.isDeadlinePickerHidden
        textView.text = state.item.text
        prioritySegmentedControl.setTodoItem(priority: state.item.priority)
        placeholderLabel.isHidden = !state.item.text.isEmpty

        if let deadline = state.item.deadline {
            deadlineSwitch.setOn(true, animated: false)
            deadlineDatePicker.setDate(deadline, animated: false)
            deadlineButton.isHidden = false
            deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
        } else {
            deadlineSwitch.setOn(false, animated: false)
        }

        setupFrameLayout()
    }

    func onCancelButtonTap() {
        store.dispatch(CloseEditorAction())
        store.unsubscribe(self)
        dismiss(animated: true)
    }

    func onSaveButtonTap() {
        store.dispatch(ItemSavedEditorAction())
    }

    @objc
    func onRemoveButtonTap() {
        store.dispatch(ItemDeletedEditorAction())
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        store.dispatch(DeadlineChangedEditorAction(deadline: deadlineSwitch.isOn ? Date() : nil))
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
        store.dispatch(DeadlineChangedEditorAction(deadline: deadlineDatePicker.date))
    }

    @objc
    func onDeadlineButtonTap() {
        store.dispatch(DeadlinePickerVisibilityAction(isHidden: !deadlineDatePicker.isHidden))
    }

    func textViewDidChange(_ textView: UITextView) {
        store.dispatch(TextChangedEditorAction(text: textView.text))
    }

    @objc
    func onPriorityChanged() {
        store.dispatch(PriorityChangedEditorAction(priority: prioritySegmentedControl.todoItemPriority))
    }
}
