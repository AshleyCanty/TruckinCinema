//
//  SnackBarCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit

enum SnackBarItemType: CaseIterable {
    case popcorn
    case beverages
    case snacks
}

class SnackBarCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SnackBarCell"
    
    lazy var foodTitleLabelLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.TextColorPrimary
        label.font = AppFont.semiBold(size: 15)
        label.textAlignment = .left
        return label
    }()
    
    lazy var rightArrowIcon: UIImageView = {
        let imgView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = AppColors.TextColorPrimary
        return imgView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.BackgroundMain
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    public var type: SnackBarItemType? {
        didSet {
            configureCellForItemType()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.shadowPath == nil && bounds.size != .zero {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15.0).cgPath
            
        }
    }
    
    /// adjusts UI based on food type
    public func configureCellForItemType() {
        guard let type = type else { return }
        switch type {
        case .popcorn:
            foodTitleLabelLabel.text = SnackBarItemMain.Popcorn.getStringVal()
            backgroundImageView.image = UIImage(imgNamed: SnackBarItemMain.Popcorn.getImage())
        case .beverages:
            foodTitleLabelLabel.text = SnackBarItemMain.Beverages.getStringVal()
            backgroundImageView.image = UIImage(imgNamed: SnackBarItemMain.Beverages.getImage())
        case .snacks:
            foodTitleLabelLabel.text = SnackBarItemMain.Snacks.getStringVal()
            backgroundImageView.image = UIImage(imgNamed: SnackBarItemMain.Snacks.getImage())
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        addShadow(color: AppTheme.ShadowColor, opacity: AppTheme.ShadowOpacity, radius: AppTheme.ShadowRadius, offset: AppTheme.ShadowOffset)
        layer.masksToBounds = false
        
        
        contentView.addSubview(wrapperView)
        wrapperView.disableTranslatesAutoresizingMaskIntoContraints()
        // no margins set becasue width is calculated in collection view's layout
        wrapperView.tc_constrainToSuperview()
        
        wrapperView.addSubview(backgroundImageView)
        backgroundImageView.disableTranslatesAutoresizingMaskIntoContraints()
        backgroundImageView.tc_constrainToSuperview()
        
        let bottomLabelView = UIView()
        bottomLabelView.backgroundColor = AppColors.BackgroundSecondary
        
        bottomLabelView.addSubviews(subviews: [foodTitleLabelLabel, rightArrowIcon])
        
        wrapperView.addSubview(bottomLabelView)
        bottomLabelView.disableTranslatesAutoresizingMaskIntoContraints()
        bottomLabelView.bottomAnchor.tc_constrain(equalTo: wrapperView.bottomAnchor)
        bottomLabelView.leadingAnchor.tc_constrain(equalTo: wrapperView.leadingAnchor)
        bottomLabelView.trailingAnchor.tc_constrain(equalTo: wrapperView.trailingAnchor)
        bottomLabelView.heightAnchor.tc_constrain(equalToConstant: 40)
        
        foodTitleLabelLabel.disableTranslatesAutoresizingMaskIntoContraints()
        foodTitleLabelLabel.leadingAnchor.tc_constrain(equalTo: bottomLabelView.leadingAnchor, constant: AppTheme.LeadingTrailingMargin)
        foodTitleLabelLabel.centerYAnchor.tc_constrain(equalTo: bottomLabelView.centerYAnchor)
        
        rightArrowIcon.disableTranslatesAutoresizingMaskIntoContraints()
        rightArrowIcon.trailingAnchor.tc_constrain(equalTo: bottomLabelView.trailingAnchor, constant: -AppTheme.LeadingTrailingMargin)
        rightArrowIcon.centerYAnchor.tc_constrain(equalTo: bottomLabelView.centerYAnchor)
        rightArrowIcon.heightAnchor.tc_constrain(equalToConstant: 21)
        rightArrowIcon.widthAnchor.tc_constrain(equalToConstant: 19)
    }
}
