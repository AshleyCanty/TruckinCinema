//
//  SignInVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/5/23.
//

import Foundation
import UIKit

/// Sign-In VC
class SignInVC: BaseViewController, AppNavigationBarDelegate, UIGestureRecognizerDelegate {
    
    /// Style struct
    fileprivate struct Style {
        
    }

    let emailField = RoundedTextField(placeholder: "Email")
    
    let passwordField = RoundedTextField(type: .Password, placeholder: "Password")
    
    let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Forgot password?", for: .normal)
        btn.setTitleColor(AppColors.TextColorPrimary, for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 12)
        btn.backgroundColor = .clear
        return btn
    }()
    
    let signInButton: UIButton = {
        let btn = RoundedButton(type: .custom)
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(AppColors.TextColorPrimary, for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 12)
        btn.backgroundColor = AppColors.RegularTeal
        return btn
    }()
    
    let notMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "Not a member?"
        label.textColor = AppColors.TextColorPrimary
        label.font = AppFont.semiBold(size: 12)
        return label
    }()
    
    let joinNowLabel: UILabel = {
        let label = UILabel()
        label.text = "Join Now."
        label.textColor = AppColors.RegularTeal
        label.font = AppFont.semiBold(size: 12)
        return label
    }()
    
    /// Custom Nav Bar
    private lazy var appNavBar = AppNavigationBar(type: .SignIn)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        addCustomNavBar()
        
        view.addSubviews(subviews: [emailField, passwordField, forgotPasswordButton,
                                    signInButton])
        
        emailField.disableTranslatesAutoresizingMaskIntoContraints()
        emailField.topAnchor.tc_constrain(equalTo: appNavBar.bottomAnchor, constant: 35)
        emailField.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        emailField.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        emailField.heightAnchor.tc_constrain(equalToConstant: RoundedTextField.Style.Height)
        
        passwordField.disableTranslatesAutoresizingMaskIntoContraints()
        passwordField.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        passwordField.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        passwordField.heightAnchor.tc_constrain(equalToConstant: RoundedTextField.Style.Height)
        passwordField.topAnchor.tc_constrain(equalTo: emailField.bottomAnchor, constant: 10)
        

        forgotPasswordButton.disableTranslatesAutoresizingMaskIntoContraints()
        forgotPasswordButton.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        forgotPasswordButton.topAnchor.tc_constrain(equalTo: passwordField.bottomAnchor, constant: 35)
        forgotPasswordButton.widthAnchor.tc_constrain(equalToConstant: 120)
        forgotPasswordButton.heightAnchor.tc_constrain(equalToConstant: 25)

        signInButton.disableTranslatesAutoresizingMaskIntoContraints()
        signInButton.centerYAnchor.tc_constrain(equalTo: forgotPasswordButton.centerYAnchor)
        signInButton.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        signInButton.heightAnchor.tc_constrain(equalToConstant: 40)
        signInButton.widthAnchor.tc_constrain(equalToConstant: 100)

        let divider = UIView()
        divider.backgroundColor = AppColors.BackgroundSecondary

        view.addSubview(divider)
        divider.disableTranslatesAutoresizingMaskIntoContraints()
        divider.topAnchor.tc_constrain(equalTo: forgotPasswordButton.bottomAnchor, constant: 35)
        divider.heightAnchor.tc_constrain(equalToConstant: 1)
        divider.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        divider.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)

        let labelStack = UIStackView(arrangedSubviews: [notMemberLabel, joinNowLabel])
        labelStack.axis = .horizontal
        labelStack.distribution = .equalCentering
        labelStack.alignment = .center
        labelStack.spacing = 2

        view.addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        labelStack.topAnchor.tc_constrain(equalTo: divider.bottomAnchor, constant: 20)

        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapJoinNowButton))
        tapGesture.delegate = self
        joinNowLabel.isUserInteractionEnabled = true
        joinNowLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapSignInButton() {
        
    }
    
    @objc func didTapForgotPasswordButton() {
        
    }
    
    @objc func didTapJoinNowButton() {
        guard let tabBarController = navigationController?.viewControllers.first(where: { type(of: $0) == TabBarController.self}) as? TabBarController else { return }
        tabBarController.selectedIndex = 3
        navigationController?.popToViewController(tabBarController, animated: true)
    }
    
    // MARK: - Custom NavBar Delegate Methods
    
    func didPressNavBarLeftButton() {}
    
    func didPressNavBarRightButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func addCustomNavBar() {
        view.addSubview(appNavBar)
        appNavBar.disableTranslatesAutoresizingMaskIntoContraints()
        appNavBar.heightAnchor.tc_constrain(equalToConstant: AppNavigationBar.Style.Height)
        appNavBar.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor)
        appNavBar.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        appNavBar.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
        appNavBar.delegate = self
        
        appNavBar.configureNavBar(withTitle: NavigationTitle.SignIn.getString())
    }
}
