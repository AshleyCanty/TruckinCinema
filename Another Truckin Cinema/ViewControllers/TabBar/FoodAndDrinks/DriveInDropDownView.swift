//
//  DriveInDropDownView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/7/23.
//

import Foundation
import UIKit

class DriveInDropDownView: UIView {
    
    let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a Participating Drive-in"
        label.font = AppFont.regular(size: 12)
        label.textColor = AppColors.RegularGray
        label.textAlignment = .left
        return label
    }()
    
    let arrowIcon = UIImageView(image: UIImage(imgNamed: "dropdown-menu-btn"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 4)
    }

    func setup() {
        backgroundColor = AppColors.BackgroundSecondary
        layer.masksToBounds = true
        
        addSubview(promptLabel)
        promptLabel.disableTranslatesAutoresizingMaskIntoContraints()
        promptLabel.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        promptLabel.leadingAnchor.tc_constrain(equalTo: leadingAnchor, constant: 12)
        
        addSubview(arrowIcon)
        arrowIcon.disableTranslatesAutoresizingMaskIntoContraints()
        arrowIcon.heightAnchor.tc_constrain(equalToConstant: 10)
        arrowIcon.widthAnchor.tc_constrain(equalToConstant: 10)
        arrowIcon.leadingAnchor.tc_constrain(greaterThanOrEqualTo: promptLabel.trailingAnchor)
        arrowIcon.trailingAnchor.tc_constrain(equalTo: trailingAnchor, constant: -12)
        arrowIcon.centerYAnchor.tc_constrain(equalTo: centerYAnchor)
        
        let dropdownBottomBorder = UIView()
        dropdownBottomBorder.backgroundColor = AppColors.RegularTeal
        
        addSubview(dropdownBottomBorder)
        dropdownBottomBorder.disableTranslatesAutoresizingMaskIntoContraints()
        dropdownBottomBorder.heightAnchor.tc_constrain(equalToConstant: 1)
        dropdownBottomBorder.widthAnchor.tc_constrain(equalTo: widthAnchor)
        dropdownBottomBorder.bottomAnchor.tc_constrain(equalTo: bottomAnchor)
    }
}
