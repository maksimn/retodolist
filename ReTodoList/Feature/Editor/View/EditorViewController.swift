//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import UIKit

final class EditorViewController: UIViewController, EditorView, UITextViewDelegate {

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

    private let model: EditorModel

    let networkIndicatorGraph: NetworkIndicatorGraph

    init(params: EditorViewParams,
         model: EditorModel,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.params = params
        self.model = model
        self.networkIndicatorGraph = networkIndicatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.dispatch(InitEditorAction(item: params.initTodoItem))
    }

    func set(state: EditorState) {
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
        model.dispatch(CloseEditorAction())
        model.unsubscribe()
        networkIndicatorGraph.model?.unsubscribe()
        dismiss(animated: true)
    }

    func onSaveButtonTap() {
        model.dispatch(ItemSavedEditorAction())
    }

    @objc
    func onRemoveButtonTap() {
        model.dispatch(ItemDeletedEditorAction())
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        model.dispatch(DeadlineChangedEditorAction(deadline: deadlineSwitch.isOn ? Date() : nil))
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
        model.dispatch(DeadlineChangedEditorAction(deadline: deadlineDatePicker.date))
    }

    @objc
    func onDeadlineButtonTap() {
        model.dispatch(DeadlinePickerVisibilityAction(isHidden: !deadlineDatePicker.isHidden))
    }

    func textViewDidChange(_ textView: UITextView) {
        model.dispatch(TextChangedEditorAction(text: textView.text))
    }

    @objc
    func onPriorityChanged() {
        model.dispatch(PriorityChangedEditorAction(priority: prioritySegmentedControl.todoItemPriority))
    }
}
