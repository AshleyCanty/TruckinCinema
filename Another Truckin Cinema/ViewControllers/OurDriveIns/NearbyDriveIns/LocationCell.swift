//
//  LocationCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/30/23.
//

import Foundation
import UIKit

class LocationCell: UITableViewCell {
    
    static let reuseId = "LocationCell"
    
    let pinIcon: UIImageView = {
        let imgView = UIImageView(image: UIImage(imgNamed: "ourDriveIns").withRenderingMode(.alwaysTemplate))
        imgView.tintColor = AppColors.TextColorPrimary
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.semiBold(size: 12)
        label.textColor = AppColors.TextColorPrimary
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        
        contentView.addSubviews(subviews: [pinIcon, locationLabel])
        
        pinIcon.disableTranslatesAutoresizingMaskIntoContraints()
        pinIcon.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: 12)
        pinIcon.heightAnchor.tc_constrain(equalToConstant: 20)
        pinIcon.widthAnchor.tc_constrain(equalToConstant: 20)
        pinIcon.centerYAnchor.tc_constrain(equalTo: contentView.centerYAnchor)
        
        locationLabel.disableTranslatesAutoresizingMaskIntoContraints()
        locationLabel.leadingAnchor.tc_constrain(equalTo: pinIcon.trailingAnchor, constant: 20)
        locationLabel.centerYAnchor.tc_constrain(equalTo: pinIcon.centerYAnchor)
    }
}
