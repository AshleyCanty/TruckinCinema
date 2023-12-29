//
//  AppUITextField.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/9/23.
//

import Foundation
import UIKit


enum RoundedTextFieldType {
    case Dropdown
    case Password
    case Plain
}

class RoundedTextField: UITextField {
    
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let BorderColor: UIColor = AppColors.BackgroundSecondary
        static let BorderActiveColor: UIColor = AppColors.RegularTeal
        static let BorderWidth: CGFloat = 1
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let TextFont: UIFont = AppFont.regular(size: 13)
        static let PlaceholderTextColor: UIColor = AppColors.RegularGray
        static let PlaceholderFont: UIFont = AppFont.regular(size: 13)
        static let IconTintColor: UIColor = AppColors.RegularGray
        static let IconSize: CGFloat = 18
        static let Padding  = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let Height: CGFloat = 45.0
    }
    
    enum IconName: String {
        case Dropdown = "dropdown-menu-btn"
        case ViewPassword = "view-password"
        case HidePassword = "hide-password"
        func getString() -> String { return self.rawValue }
    }
    
    private lazy var iconButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate) ?? UIImage(), for: .normal)
        if type == .Password {
            btn.setImage(UIImage(imgNamed: IconName.ViewPassword.getString()), for: .selected)
        }
        return btn
    }()
    /// type of textfield
    private var type: RoundedTextFieldType = .Plain {
        didSet {
            setupIcon()
        }
    }
    /// placeholder text
    private var placeholderText: String? {
        didSet {
            setupPlaceholder()
        }
    }
    /// name of icon image
    private var icon: String {
        switch type {
        case .Dropdown: return IconName.Dropdown.getString()
        case .Password: return IconName.HidePassword.getString()
        case .Plain: return ""
        }
    }
    
    init(type: RoundedTextFieldType = .Plain, placeholder text: String = "") {
        super.init(frame: .zero)
        font = Style.TextFont
        self.type = type
        placeholderText = !text.isEmpty ? text : nil
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Style.Padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Style.Padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Style.Padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    public func setup(type: RoundedTextFieldType = .Plain, placeholder text: String = "") {
        self.type = type
        placeholderText = !text.isEmpty ? text : nil
    }
    
    private func configure() {
        backgroundColor = Style.BackgroundColor
        layer.borderColor = Style.BorderColor.cgColor
        layer.borderWidth = Style.BorderWidth
        textColor = Style.TextColor
        
        addSubview(iconButton)
        iconButton.disableTranslatesAutoresizingMaskIntoContraints()
        iconButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -12)
        iconButton.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        iconButton.heightAnchor.tc_constrain(equalToConstant: Style.IconSize)
        iconButton.widthAnchor.tc_constrain(equalToConstant: Style.IconSize)
        
        setupIcon()
        setupPlaceholder()
    }
    
    private func setupIcon() {
        switch type {
        case .Plain:
            break
        case .Password:
            iconButton.addTarget(self, action: #selector(didTapPasswordButton), for: .touchUpInside)
            iconButton.setImage(UIImage(imgNamed: "hide-password").withRenderingMode(.alwaysTemplate), for: .normal)
            iconButton.imageView?.tintColor = AppColors.RegularGray
            isSecureTextEntry = true
        case .Dropdown:
            iconButton.setImage(UIImage(imgNamed: "dropdown-menu-btn").withRenderingMode(.alwaysTemplate), for: .normal)
            iconButton.imageView?.tintColor = AppColors.RegularGray
        }
    }
    
    private func setupPlaceholder() {
        if let placeholder = placeholderText {
            let attributes = [NSMutableAttributedString.Key.font: Style.PlaceholderFont, NSMutableAttributedString.Key.foregroundColor: Style.PlaceholderTextColor]
            let attrString = NSMutableAttributedString(string: placeholder, attributes: attributes)
            attributedPlaceholder =  attrString
        }
    }
    
    @objc private func didTapPasswordButton() {
        guard type == .Password else { return }
        iconButton.isSelected  = !iconButton.isSelected
        isSecureTextEntry = !isSecureTextEntry
    }
}
