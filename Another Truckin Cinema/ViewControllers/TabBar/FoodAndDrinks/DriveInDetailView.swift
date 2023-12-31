//
//  DriveInDetailView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/7/23.
//

import Foundation
import UIKit

class DriveInDetailView: UIView {
    
    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Delivery to Car"
        label.textColor = RegistrationVC.Style.TitleTextColor
        label.font = RegistrationVC.Style.TitleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "AT THIS DRIVE-IN"
        label.textColor = AppColors.RegularGray
        label.font = AppFont.regular(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Head straight to your screen lot, get comfy and we’ll deliver your order to your seat at the time you chose!"
        label.textColor = AppColors.TextColorPrimary
        label.font = RegistrationVC.Style.BodyTextFont
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.allCorners], radius: 12)
    }
    
    private func setup() {
        layer.masksToBounds = true
        backgroundColor = AppColors.BackgroundSecondary

        let stack = UIStackView(arrangedSubviews: [subTitleLabel, largeTitleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 8
        stack.setCustomSpacing(15, after: largeTitleLabel)
        
        addSubview(stack)
        stack.disableTranslatesAutoresizingMaskIntoContraints()
        stack.topAnchor.tc_constrain(equalTo: topAnchor, constant: 12)
        stack.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 12)
        stack.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -12)
    }
}
