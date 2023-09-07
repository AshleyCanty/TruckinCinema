//
//  CompareLevelsCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/31/23.
//

import Foundation
import UIKit

class CompareLevelsCell: UITableViewCell {
    
    static let reuseId = "CompareLevelsCell"
    
    let compareLabel: UILabel = {
        let label = UILabel()
        label.text = "Compare Levels of Truckin' Cinema Tiers"
        label.font = AppFont.semiBold(size: 12)
        label.textColor = AppColors.RegularTeal
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = AppColors.BackgroundMain
        contentView.backgroundColor = AppColors.BackgroundMain
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(compareLabel)
        compareLabel.disableTranslatesAutoresizingMaskIntoContraints()
        compareLabel.tc_constrainToSuperview()
    }
}
