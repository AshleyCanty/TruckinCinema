//
//  DropDownTextFieldView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/16/23.
//

import Foundation
import UIKit
import DropDown

protocol DropDownTextFieldViewDelegate: AnyObject {
//    func didTapTextFieldDropdown()
    func didSelectDropDownOption(sender: UITextField)
}

class DropDownTextFieldView: UIView, UIGestureRecognizerDelegate {
    /// textfield
    public lazy var textField = RoundedTextField(type: .Dropdown)
    /// Dropdown
    public let dropDown = DropDown()
    /// datasource
    public var dataSource: [String] = []
    /// delegate
    weak var delegate: DropDownTextFieldViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(textField)
        textField.disableTranslatesAutoresizingMaskIntoContraints()
        textField.tc_constrainToSuperview()
        textField.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextFieldDropdown))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        dropDown.shadowOpacity = AppTheme.ShadowOpacity
        dropDown.anchorView = textField
        dropDown.bottomOffset = CGPoint(x: 0, y: RoundedTextField.Style.Height + 5)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textField.text = item
            delegate?.didSelectDropDownOption(sender: textField)
        }
    }
    
    
    @objc private func didTapTextFieldDropdown() {
        NotificationCenter.default.post(name: NSNotification.Name(AppNotificationNames.HideKeyboard), object: nil)
        dropDown.show()
    }
    
    public func setDataSource(dataSource: [String]) {
        self.dataSource = dataSource
        dropDown.dataSource = dataSource
    }
}

