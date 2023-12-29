//
//  FavoriteDriveInsVC.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/26/23.
//

import Foundation
import UIKit


class FavoriteDriveInsVC: BaseViewController {
    
    struct Style {
        static let JoinButtonBorderWidth: CGFloat = 1
        static let JoinButtonBorderColor: UIColor = AppColors.TextColorPrimary
        static let JoinButtonTitleLabelFont: UIFont = AppFont.semiBold(size: 12)
        static let JoinButtonTextColor: UIColor = AppColors.TextColorPrimary
        static let ButtonWidth: CGFloat = 140
        static let ButtonHeight: CGFloat = 40
        static let JoinButtonTrailingMargin: CGFloat = 12
        static let JoinButtonBottomMargin: CGFloat = 12
    }
    
    let logoImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "LaunchScreen-logo"))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let memberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MEMBERSHIP EXCLUSIVE"
        label.font = AppFont.semiBold(size: 15)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .center
        return label
    }()
    
    let signInPromptTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in with your ATC account to use this feature. If you don't have one, you can join for free."
        label.font = AppFont.regular(size: 13)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// 'Sign up' button
    fileprivate lazy var signInButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.backgroundColor = .white
        button.setTitle(ButtonTitle.SignIn.getString(), for: .normal)
        button.setTitleColor(AppColors.BackgroundMain, for: .normal)
        button.titleLabel?.font = Style.JoinButtonTitleLabelFont
        return button
    }()
    
    /// 'Sign up' button
    fileprivate lazy var joinButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.addBorder(color: Style.JoinButtonBorderColor, width: Style.JoinButtonBorderWidth)
        button.backgroundColor = .clear
        button.setTitle(ButtonTitle.SignUp.getString(), for: .normal)
        button.setTitleColor(Style.JoinButtonTextColor, for: .normal)
        button.titleLabel?.font = Style.JoinButtonTitleLabelFont
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubviews(subviews: [logoImageView, memberTitleLabel, signInPromptTitleLabel, signInButton, joinButton])
        
        logoImageView.disableTranslatesAutoresizingMaskIntoContraints()
        logoImageView.heightAnchor.tc_constrain(equalToConstant: 110)
        logoImageView.widthAnchor.tc_constrain(equalToConstant: 280)
        logoImageView.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        logoImageView.topAnchor.tc_constrain(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        
        memberTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        memberTitleLabel.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        memberTitleLabel.topAnchor.tc_constrain(equalTo: logoImageView.bottomAnchor, constant: 0)
        
        signInPromptTitleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        signInPromptTitleLabel.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        signInPromptTitleLabel.topAnchor.tc_constrain(equalTo: memberTitleLabel.bottomAnchor, constant: 30)
        signInPromptTitleLabel.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: 12)
        signInPromptTitleLabel.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: -12)
        
        signInButton.disableTranslatesAutoresizingMaskIntoContraints()
        signInButton.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        signInButton.topAnchor.tc_constrain(equalTo: signInPromptTitleLabel.bottomAnchor, constant: 30)
        signInButton.heightAnchor.tc_constrain(equalToConstant: Style.ButtonHeight)
        signInButton.widthAnchor.tc_constrain(equalToConstant: Style.ButtonWidth)
        
        joinButton.disableTranslatesAutoresizingMaskIntoContraints()
        joinButton.centerXAnchor.tc_constrain(equalTo: view.centerXAnchor)
        joinButton.topAnchor.tc_constrain(equalTo: signInButton.bottomAnchor, constant: 15)
        joinButton.heightAnchor.tc_constrain(equalToConstant: Style.ButtonHeight)
        joinButton.widthAnchor.tc_constrain(equalToConstant: Style.ButtonWidth)
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(didTapJoinButton), for: .touchUpInside)
    }
    
    @objc func didTapSignInButton() {
        AppNavigation.shared.navigateTo(SignInVC())
    }
    
    @objc func didTapJoinButton() {
        tabBarController?.selectedIndex = 3
    }
}
