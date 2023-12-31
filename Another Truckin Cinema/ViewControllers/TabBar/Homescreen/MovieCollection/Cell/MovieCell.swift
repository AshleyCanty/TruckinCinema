//
//  MovieCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/15/23.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell {
    
    struct Style {
        static let CellHeight: CGFloat = 260
        static let TitleTextColor: UIColor = AppColors.TextColorPrimary
        static let TitleTextFont: UIFont = AppFont.semiBold(size: 11)
        static let TitleBackgroundColor: UIColor = AppColors.BackgroundSecondary
        static let CornerRadius: CGFloat = 15
        static let TitleViewHeight: CGFloat = 45
    }
    
    static let reuseIdentifier: String = "MovieCell"
    
    /// poster image view
    public var posterImageView: CustomImageView = {
        let imageview = CustomImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = Style.CornerRadius
        imageview.backgroundColor = AppColors.BannerCollectionBGColor
        return imageview
    }()
    
    public var titleLabel: UILabel = {
        let label = PaddedLabel()
        label.padding(0, 0, 8, 8)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = Style.TitleTextColor
        label.font = Style.TitleTextFont
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// configures cell . Refactor to add real data
    fileprivate func configure() {
        contentView.addShadow(color: AppTheme.ShadowColor, opacity: AppTheme.ShadowOpacity, radius: AppTheme.ShadowRadius, offset: AppTheme.ShadowOffset)
        contentView.backgroundColor = .clear
        
        let titleView = UIView()
        titleView.backgroundColor = Style.TitleBackgroundColor
        titleView.addSubview(titleLabel)
        
        posterImageView.addSubview(titleView)
        contentView.addSubviews(subviews: [posterImageView])
        
        posterImageView.disableTranslatesAutoresizingMaskIntoContraints()
        posterImageView.tc_constrainToSuperview()
        
        titleView.disableTranslatesAutoresizingMaskIntoContraints()
        titleView.heightAnchor.tc_constrain(equalToConstant: Style.TitleViewHeight)
        titleView.bottomAnchor.tc_constrain(equalTo: posterImageView.bottomAnchor)
        titleView.leadingAnchor.tc_constrain(equalTo: posterImageView.leadingAnchor)
        titleView.trailingAnchor.tc_constrain(equalTo: posterImageView.trailingAnchor)
        
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.tc_constrainToSuperview()
    }
}
