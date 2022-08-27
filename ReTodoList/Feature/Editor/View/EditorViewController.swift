//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

final class EditorViewController: UIViewController, EditorView, UITextViewDelegate {

    let params: EditorViewParams
    private let model: EditorModel
    let networkIndicatorGraph: UDFGraph

    lazy var navBar = EditorNavBar(
        params: EditorNavBarParams(
            save: params.navBarStrings.save,
            todo: params.navBarStrings.todo,
            cancel: params.navBarStrings.cancel,
            navigationItem: navigationItem,
            networkIndicatorView: networkIndicatorGraph.view,
            onSaveButtonTap: { [weak self] in
                self?.onSaveButtonTap()
            },
            onCancelButtonTap: { [weak self] in
                self?.onCancelButtonTap()
            }
        )
    )
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
        model.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.subscribe()
        networkIndicatorGraph.model?.subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.unsubscribe()
        networkIndicatorGraph.model?.unsubscribe()
    }

    func set(state: EditorState) {
        navBar.setSaveButton(state.canItemBeSaved)
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
            deadlineButton.setTitle(deadline.formattedDate, for: .normal)
        } else {
            deadlineSwitch.setOn(false, animated: false)
        }

        setupFrameLayout()
    }

    func onCancelButtonTap() {
        model.close()
        dismiss(animated: true)
    }

    func onSaveButtonTap() {
        model.save()
    }

    @objc
    func onRemoveButtonTap() {
        model.delete()
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        model.set(deadline: deadlineSwitch.isOn ? Date() : nil)
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
        model.set(deadline: deadlineDatePicker.date)
    }

    @objc
    func onDeadlineButtonTap() {
        model.set(isDeadlinePickerHidden: !deadlineDatePicker.isHidden)
    }

    func textViewDidChange(_ textView: UITextView) {
        model.set(text: textView.text)
    }

    @objc
    func onPriorityChanged() {
        model.set(priority: prioritySegmentedControl.todoItemPriority)
    }
}
