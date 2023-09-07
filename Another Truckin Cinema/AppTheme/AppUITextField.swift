//
//  AppUITextField.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/9/23.
//

import Foundation
import UIKit


enum AppTextFieldType {
    case Dropdown
    case Password
    case Plain
}

class RoundedTextField: UITextField {
    
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let BorderColor: UIColor = AppColors.BackgroundSecondary
        static let BorderWidth: Int = 1
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let TextFont: UIFont = AppFont.regular(size: 12)
        static let PlaceholderTextColor: UIColor = AppColors.RegularGray
        static let PlaceholderFont: UIFont = AppFont.regular(size: 12)
        static let IconTintColor: UIColor = AppColors.RegularGray
        static let IconSize: CGFloat = 20
    }
    
    enum IconName: String {
        case Dropdown = "dropdown-menu-btn"
        case Password = "view-password"
        func getString() -> String { return self.rawValue }
    }
    
    private lazy var iconButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate) ?? UIImage(), for: .normal)
        return btn
    }()
    
    /// type of textfield
    private var type: AppTextFieldType = .Plain
    /// placeholder text
    private var placeholderText: String?
    /// name of icon image
    private var icon: String {
        switch type {
        case .Dropdown: return IconName.Dropdown.getString()
        case .Password: return IconName.Password.getString()
        case .Plain: return ""
        }
    }
    
    init(type: AppTextFieldType = .Plain, placeholder text: String = "") {
        super.init(frame: .zero)
        self.type = type
        placeholderText = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configure() {
        backgroundColor = Style.BackgroundColor
        
        if let placeholder = placeholderText {
            let attributes = [NSMutableAttributedString.Key.font: Style.PlaceholderFont, NSMutableAttributedString.Key.foregroundColor: Style.PlaceholderTextColor]
            let attrString = NSMutableAttributedString(string: placeholder, attributes: attributes)
            attributedPlaceholder =  attrString
        }
    }
}
