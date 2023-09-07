//
//  SignUpView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/13/23.
//

import Foundation
import UIKit

protocol SignUpBannerViewDelegate: AnyObject {
    func didPressSignUpButton()
}

class SignUpBannerView: UIView, UIGestureRecognizerDelegate {

    /// Style struct
    public struct Style {
        static let BannerCornerRadius: CGFloat = 15
        static let DescriptionFont: UIFont = AppFont.medium(size: 13)
        static let DescriptionTextColor: UIColor = AppColors.TextColorPrimary
        static let DescriptionTopMargin: CGFloat = 12
        static let DescriptionLeadingMargin: CGFloat = 8
        static let DescriptionTrailingMargin: CGFloat = 12
        static let JoinButtonBorderWidth: CGFloat = 1
        static let JoinButtonBorderColor: UIColor = AppColors.TextColorPrimary
        static let JoinButtonTitleLabelFont: UIFont = AppFont.semiBold(size: 11)
        static let JoinButtonTextColor: UIColor = AppColors.TextColorPrimary
        static let JoinButtonWidth: CGFloat = 70
        static let JoinButtonContentInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 15, bottom: 8, trailing: 15)
        static let JoinButtonContentEdgeInsets: UIEdgeInsets = .init(top: 8, left: 15, bottom: 8, right: 15)
        static let JoinButtonTrailingMargin: CGFloat = 12
        static let JoinButtonBottomMargin: CGFloat = 12
        static let RibbonViewTopMargin: CGFloat = 12
        static let RibbonViewLeadingMargin: CGFloat = 12
        static let RibbonViewBGColor: UIColor = AppColors.BannerSignupRibbonBackground
        static let RibbonPadding: CGFloat = 12
        static let RibbonIconImageSize: CGFloat = 28
    }
    
    /// 'Sign up' button
    fileprivate lazy var joinButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.addBorder(color: Style.JoinButtonBorderColor, width: Style.JoinButtonBorderWidth)

        if #available(iOS 15, *) {
            let titleAttributes = AttributeContainer([
                NSAttributedString.Key.font: Style.JoinButtonTitleLabelFont,
                NSAttributedString.Key.foregroundColor: Style.JoinButtonTextColor
             ])
            
            var buttonConfig = UIButton.Configuration.bordered()
            buttonConfig.contentInsets = Style.JoinButtonContentInsets
            buttonConfig.attributedTitle = AttributedString(ButtonTitle.SignUp.getString(), attributes: titleAttributes)
            buttonConfig.baseBackgroundColor = .clear
            button.configuration = buttonConfig
        } else {
            button.backgroundColor = .clear
            button.contentEdgeInsets = Style.JoinButtonContentEdgeInsets
            button.setTitle(ButtonTitle.SignUp.getString(), for: .normal)
            button.titleLabel?.textColor = Style.JoinButtonTextColor
            button.titleLabel?.font = Style.JoinButtonTitleLabelFont
        }

        return button
    }()
    
    /// Ribbon icon
    fileprivate lazy var ribbonImageView: UIImageView = {
        let icon = UIImageView(image: UIImage(imgNamed: BannerIcon.SignUp.getString()))
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    /// Ribbon icon view
    fileprivate lazy var ribbonIconView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.RibbonViewBGColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
        
    /// Banner image view
    fileprivate lazy var bannerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(imgNamed: BannerImage.SignUp.getString()))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Description label
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = BannerDescription.SignUp.getString()
        label.textColor = Style.DescriptionTextColor
        label.font = Style.DescriptionFont
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    weak var delegate: SignUpBannerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented.")
    }

    /// Sets up views
    fileprivate func setupViews() {
        ribbonIconView.addSubview(ribbonImageView)
        addSubviews(subviews: [bannerImage, joinButton, descriptionLabel, ribbonIconView])
        
        /// Setup constraints
        bannerImage.disableTranslatesAutoresizingMaskIntoContraints()
        ribbonImageView.disableTranslatesAutoresizingMaskIntoContraints()
        ribbonIconView.disableTranslatesAutoresizingMaskIntoContraints()
        descriptionLabel.disableTranslatesAutoresizingMaskIntoContraints()
        joinButton.disableTranslatesAutoresizingMaskIntoContraints()
        
        /// banner image constraints
        bannerImage.tc_constrainToSuperview()
        
        /// ribbon image view constraints
        ribbonImageView.heightAnchor.tc_constrain(equalToConstant: Style.RibbonIconImageSize)
        ribbonImageView.widthAnchor.tc_constrain(equalToConstant: Style.RibbonIconImageSize)
        ribbonImageView.centerYAnchor.tc_constrain(equalTo: ribbonIconView.centerYAnchor)
        ribbonImageView.centerXAnchor.tc_constrain(equalTo: ribbonIconView.centerXAnchor)
        
        /// ribbon wrapper view constraints
        ribbonIconView.widthAnchor.tc_constrain(equalToConstant: (Style.RibbonIconImageSize + Style.RibbonPadding))
        ribbonIconView.heightAnchor.tc_constrain(equalToConstant: (Style.RibbonIconImageSize + Style.RibbonPadding))
        ribbonIconView.topAnchor.tc_constrain(equalTo: topAnchor, constant: Style.RibbonViewTopMargin)
        ribbonIconView.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: Style.RibbonViewLeadingMargin)
        
        /// description constraints
        descriptionLabel.topAnchor.tc_constrain(equalTo: topAnchor, constant: Style.DescriptionTopMargin)
        descriptionLabel.leadingAnchor.tc_constrain(equalTo: ribbonIconView.trailingAnchor, constant: Style.DescriptionLeadingMargin)
        descriptionLabel.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.DescriptionTrailingMargin)
        
        /// Signup button constraints
        joinButton.topAnchor.tc_constrain(equalTo: descriptionLabel.bottomAnchor)
        joinButton.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -Style.JoinButtonTrailingMargin)
        joinButton.bottomAnchor.tc_constrain(equalTo: bottomAnchor, constant: -Style.JoinButtonBottomMargin)
        
        joinButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressButton))
        tapGesture.delegate = self
        joinButton.isUserInteractionEnabled = true
        joinButton.addGestureRecognizer(tapGesture)
    }
    
    /// triggers delegate method
    @objc private func didPressButton() {
        delegate?.didPressSignUpButton()
    }
    
    public func getSignUpButtonFrame() -> CGRect {
        return joinButton.frame
    }
}
