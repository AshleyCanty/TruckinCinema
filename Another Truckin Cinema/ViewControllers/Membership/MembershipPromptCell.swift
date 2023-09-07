//
//  MembershipPromptCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/31/23.
//

import Foundation
import UIKit
import Combine

class MembershipPromptCell: UITableViewCell {
    
    static let reuseId = "MembershipPromptCell"
    
    struct Style {
        static let JoinButtonBorderWidth: CGFloat = 1
        static let JoinButtonBorderColor: UIColor = AppColors.TextColorPrimary
        static let JoinButtonTitleLabelFont: UIFont = AppFont.semiBold(size: 11)
        static let JoinButtonTextColor: UIColor = AppColors.TextColorPrimary
        static let ButtonWidth: CGFloat = 65
        static let ButtonHeight: CGFloat = 25
        static let JoinButtonTrailingMargin: CGFloat = 12
        static let JoinButtonBottomMargin: CGFloat = 12
    }
    
    let currentMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "Already a member?"
        label.font = AppFont.semiBold(size: 17)
        label.textColor = AppColors.TextColorPrimary
        return label
    }()
    
    let notMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "Not a member? Join Now:"
        label.font = AppFont.semiBold(size: 14)
        label.textColor = AppColors.TextColorPrimary
        return label
    }()
    
    // 'Join' button
    fileprivate lazy var signInButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.addBorder(color: Style.JoinButtonBorderColor, width: Style.JoinButtonBorderWidth)
        button.backgroundColor = .clear
        button.setTitle(ButtonTitle.SignIn.getString(), for: .normal)
        button.setTitleColor(Style.JoinButtonTextColor, for: .normal)
        button.titleLabel?.font = Style.JoinButtonTitleLabelFont
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    var cancellable: AnyCancellable?
    
    let tapSignInButton = PassthroughSubject<Void, Never>()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapSignInButton() {
        tapSignInButton.send()
    }
    
    private func setup() {
        contentView.addSubviews(subviews: [currentMemberLabel, notMemberLabel, signInButton])
        
        currentMemberLabel.disableTranslatesAutoresizingMaskIntoContraints()
        currentMemberLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        currentMemberLabel.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: 20)
        
        notMemberLabel.disableTranslatesAutoresizingMaskIntoContraints()
        notMemberLabel.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        notMemberLabel.bottomAnchor.tc_constrain(equalTo: contentView.bottomAnchor, constant: -5)
        
        signInButton.disableTranslatesAutoresizingMaskIntoContraints()
        signInButton.centerYAnchor.tc_constrain(equalTo: currentMemberLabel.centerYAnchor)
        signInButton.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -12)
        signInButton.heightAnchor.tc_constrain(equalToConstant: Style.ButtonHeight)
        signInButton.widthAnchor.tc_constrain(equalToConstant: Style.ButtonWidth)
    }
}
