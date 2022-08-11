//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ReSwift
import UIKit

final class EditorViewController: UIViewController, UITextViewDelegate {

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

    init(params: EditorViewParams) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSaveButton(enabled: Bool) {
        navBar?.setSaveButton(enabled)
    }

    func setRemoveButton(enabled: Bool) {
        removeButton.setTitleColor(enabled ? .systemRed : .systemGray, for: .normal)
        removeButton.isEnabled = enabled
    }

    func clear() {
        deadlineDatePicker.isHidden = true
        separatorViewTwo.isHidden = true
        deadlineButton.isHidden = true
        textView.text = ""
        prioritySegmentedControl.selectedSegmentIndex = 1
        placeholderLabel.isHidden = false
        deadlineSwitch.setOn(false, animated: false)
        removeButton.setTitleColor(.systemGray, for: .normal)
        setupFrameLayout()
    }

    func setTextPlaceholder(visible: Bool) {
        placeholderLabel.isHidden = !visible
    }

    func setDeadlineButton(visible: Bool) {
        deadlineButton.isHidden = !visible
    }

    func updateDeadlineButtonTitle() {
    }

    func setDeadlineDatePicker(visible: Bool) {
        deadlineDatePicker.isHidden = !visible
        separatorViewTwo.isHidden = deadlineDatePicker.isHidden
    }

    var isDeadlineDatePickerVisible: Bool {
        !deadlineDatePicker.isHidden
    }

    // MARK: - User Actions

    func onCancelButtonTap() {
        dismiss(animated: true)
    }

    func onSaveButtonTap() {
    }

    @objc
    func onRemoveButtonTap() {
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        setupFrameLayout()
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
    }

    @objc
    func onDeadlineButtonTap() {
        setDeadlineDatePicker(visible: deadlineDatePicker.isHidden)
        setupFrameLayout()
    }

    func textViewDidChange(_ textView: UITextView) {
    }

    @objc
    func onPriorityChanged() {
    }
}
