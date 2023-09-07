//
//  ContactInfoView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/17/23.
//

import Foundation
import UIKit

protocol ContactInfoViewDelegate: AnyObject {
    func didPressAddEmailButton()
}

class ContactInfoView: UIView {
    
    /// struct Style
    struct Style {
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let SubtitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let ButtonWidth: CGFloat = 215
        static let ButtonHeight: CGFloat = 50
    }
    
    /// contact info title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TextColor
        label.font = Style.TitleFont
        label.textAlignment = .left
        label.text = "Contact Info"
        return label
    }()
    /// contact info subtitle label
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.TextColor
        label.font = Style.SubtitleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Your receipt and order confirmation will  be sent to this email address."
        return label
    }()
    /// enter-email button
    public lazy var emailButton: RoundedButton = {
        let btn = RoundedButton(type: .custom)
        btn.backgroundColor = AppColors.BackgroundSecondary
        btn.setTitle("Add Email Address", for: .normal)
        btn.titleLabel?.font = AppFont.semiBold(size: 13)
        btn.setTitleColor(AppColors.RegularTeal, for: .normal)
        btn.setTitleColor(AppColors.EmailButtonTitleHighlighted, for: .highlighted)
        btn.setImage(UIImage(imgNamed: "add"), for: .normal)
        btn.setImage(UIImage(imgNamed: "add-highlighted"), for: .highlighted)
        btn.setBackgroundImage(AppColors.BackgroundSecondary.image(), for: .normal)
        btn.setBackgroundImage(AppColors.EmailButtonHighlighted.image(), for: .highlighted)
        btn.contentHorizontalAlignment = .center
        btn.imageView?.tintColor = AppColors.RegularTeal
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.borderless()
            config.imagePadding = 5
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = AppFont.semiBold(size: 13)
                return outgoing
            }
            btn.configuration = config
   
        } else {
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        }
        
        return btn
    }()
    
    weak var delegate: ContactInfoViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = AppColors.BackgroundMain
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 3
        
        addSubview(labelStack)
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.topAnchor.tc_constrain(equalTo: topAnchor)
        labelStack.leadingAnchor.tc_constrain(equalTo: leadingAnchor)
        labelStack.trailingAnchor.tc_constrain(equalTo: trailingAnchor)
        
        addSubview(emailButton)
        emailButton.disableTranslatesAutoresizingMaskIntoContraints()
        emailButton.centerXAnchor.tc_constrain(equalTo: centerXAnchor)
        emailButton.widthAnchor.tc_constrain(equalToConstant: Style.ButtonWidth)
        emailButton.heightAnchor.tc_constrain(equalToConstant: Style.ButtonHeight)
        emailButton.topAnchor.tc_constrain(equalTo: labelStack.bottomAnchor, constant: 30)
        emailButton.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
        
        emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
    }
 
    @objc func didTapEmailButton() {
        delegate?.didPressAddEmailButton()
    }
}
