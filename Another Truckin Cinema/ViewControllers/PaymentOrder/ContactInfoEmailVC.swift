//
//  ContactInfoEmailVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/17/23.
//

import Foundation
import UIKit

class ContactInfoEmailVC: BaseViewController, AppNavigationBarDelegate {
    
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let SubtitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
    }
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .ContactInfo, shouldShowTimer: false)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular(size: 13)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        label.text = "Edit Your Email Address"
        return label
    }()
    
    public lazy var textField = RoundedTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavBar()
        setupUI()
    }
    
    private func setupUI() {
        textField.setup(placeholder: "Email")
        textField.disableTranslatesAutoresizingMaskIntoContraints()
        textField.heightAnchor.tc_constrain(equalToConstant: 45)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.disableTranslatesAutoresizingMaskIntoContraints()
        stack.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: 20)
        stack.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        stack.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
    }
    
    
    // MARK: - Custom NavBar methods
    
    func didPressNavBarLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didPressNavBarRightButton() { }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: "Contact Info", withSubtitle: "")
    }
}
