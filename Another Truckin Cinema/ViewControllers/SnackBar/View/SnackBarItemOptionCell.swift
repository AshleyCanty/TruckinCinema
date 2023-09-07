//
//  SnackBarItemOptionCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit


class SnackBarItemOptionCell: UICollectionViewCell {
    
    static let reuseID = "SnackBarItemOptionCell"
    
    private var itemImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.semiBold(size: 13)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular(size: 12)
        label.textColor = AppColors.TextColorPrimary
        label.textAlignment = .left
        return label
    }()
    
    public var item: SnackBarItemModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.shadowPath == nil {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
        }
    }
    
    public func configure(image: UIImage, item: SnackBarItemModel) {
        self.item = item
        nameLabel.text = item.name
        priceLabel.text = item.priceString
        itemImageView.image = image
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = AppColors.BackgroundSecondary
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        addShadow(color: AppTheme.ShadowColor, opacity: AppTheme.ShadowOpacity, radius: AppTheme.ShadowRadius, offset: AppTheme.ShadowOffset)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .leading
        labelStack.spacing = 6
        
        contentView.addSubviews(subviews: [itemImageView, labelStack])
        
        itemImageView.disableTranslatesAutoresizingMaskIntoContraints()
        itemImageView.heightAnchor.tc_constrain(equalToConstant: 72)
        itemImageView.widthAnchor.tc_constrain(equalToConstant: 72)
        itemImageView.centerYAnchor.tc_constrain(equalTo: contentView.centerYAnchor)
        itemImageView.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        
        labelStack.disableTranslatesAutoresizingMaskIntoContraints()
        labelStack.leadingAnchor.tc_constrain(equalTo: itemImageView.trailingAnchor, constant: AppTheme.LeadingTrailingMargin)
        labelStack.centerYAnchor.tc_constrain(equalTo: itemImageView.centerYAnchor)
    }
}



