//
//  PasswordCheckerPill.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/3/23.
//

import Foundation
import UIKit

class PasswordCheckerPill: UIView {
    
    public let titleLabel: UILabel = {
        let label = PaddedLabel()
        label.font = RegistrationVC.Style.PasswordCheckerPillFont
        label.textColor = RegistrationVC.Style.PasswordCheckerPillTextColor
        label.padding(3, 3, 25, 8)
        return label
    }()
    
    let checkmarkIcon: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "check").withRenderingMode(.alwaysTemplate))
        imgView.tintColor = RegistrationVC.Style.PasswordCheckerPillTextColor
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    /// True if views should be update to active state
    var isEnabled: Bool = false {
        didSet {
            updateViews()
        }
    }
    
    public var type: PasswordCheckerType = .LowercaseLetter

    
    init(type: PasswordCheckerType) {
        super.init(frame: .zero)
        backgroundColor = RegistrationVC.Style.PasswordCheckerPillColor
        self.type = type
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    private func updateViews() {
        checkmarkIcon.tintColor = isEnabled ? RegistrationVC.Style.PasswordCheckerPillTextColorActive : RegistrationVC.Style.PasswordCheckerPillTextColor
        titleLabel.textColor = isEnabled ? RegistrationVC.Style.PasswordCheckerPillTextColorActive : RegistrationVC.Style.PasswordCheckerPillTextColor
        backgroundColor = isEnabled ? RegistrationVC.Style.PasswordCheckerPillColorActive : RegistrationVC.Style.PasswordCheckerPillColor
    }
    
    private func configure() {
        titleLabel.text = type.getString()
        checkmarkIcon.disableTranslatesAutoresizingMaskIntoContraints()
        checkmarkIcon.heightAnchor.tc_constrain(equalToConstant: 13)
        checkmarkIcon.widthAnchor.tc_constrain(equalToConstant: 13)

        addSubview(titleLabel)
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.tc_constrainToSuperview()
        
        addSubview(checkmarkIcon)
        checkmarkIcon.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        checkmarkIcon.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 8)
        
    }
}
