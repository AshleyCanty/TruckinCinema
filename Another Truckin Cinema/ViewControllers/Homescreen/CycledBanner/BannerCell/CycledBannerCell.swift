//
//  CycledBannerCell.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/10/23.
//

import Foundation
import UIKit

/// CycledBannerCell class
class CycledBannerCell: UICollectionViewCell {
    /// Style struct
    struct Style {
        static let DescriptionFont: UIFont = AppFont.semiBold(size: 13)
        static let DescriptionTextColor: UIColor = .white
        static let DescriptionTopMargin: CGFloat = 12.0
        static let GradientViewColors: [UIColor] = [.black.withAlphaComponent(0.8), .clear]
        static let GradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
        static let GradientEndPoint: CGPoint = CGPoint(x: 0.0, y: 0.85)
    }
    
    static let reuseIdentifier: String = "CycledBannerCell"
    
    /// Gradient layer to be added to bannerImage
    fileprivate let gradient = CAGradientLayer()

    /// Banner description label
    fileprivate var bannerDescription: UILabel = {
        let label = UILabel()
        label.textColor = Style.DescriptionTextColor
        label.font = Style.DescriptionFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    /// Banner image view
    fileprivate var bannerImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    /// Banner item
    public var item: BannerItem? {
        didSet {
            setupViews()
        }
    }

    /// Accepts & assigns params to 'item' and 'gradientSize' properties to trigger cell UI set up
    public func setup(item: BannerItem, gradientSize: CGSize) {
        setupGradient(gradientSize)
        self.item = item
    }
    
    /// Sets up gradient properties and adds it to bannerImage
    fileprivate func setupGradient(_ size: CGSize) {
        gradient.setVerticalGradient(withColors: Style.GradientViewColors, startPoint: Style.GradientStartPoint, endPoint: Style.GradientEndPoint)
        gradient.frame = CGRect(origin: .zero, size: size)
        bannerImage.layer.insertSublayer(gradient, at: 0)
    }

    /// Sets up the views
    fileprivate func setupViews() {
        guard let item = item else { return }
        bannerImage.image = UIImage(imgNamed: item.bannerImage.getString())
        bannerDescription.text = item.description.getString()
        contentView.addSubviews(subviews: [bannerImage, bannerDescription])
        
        /// bannerImage constraints
        bannerImage.disableTranslatesAutoresizingMaskIntoContraints()
        bannerImage.tc_constrainToSuperview()

        /// bannerDescription constraints
        bannerDescription.disableTranslatesAutoresizingMaskIntoContraints()
        bannerDescription.topAnchor.tc_constrain(equalTo: contentView.topAnchor, constant: Style.DescriptionTopMargin)
        bannerDescription.leadingAnchor.tc_constrain(equalTo: contentView.leadingAnchor, constant: Style.DescriptionTopMargin)
        bannerDescription.trailingAnchor.tc_constrain(equalTo: contentView.trailingAnchor, constant: -Style.DescriptionTopMargin)
        
        /// Set text alignment based on banner display
        let bannerImageType = BannerImage(rawValue: item.bannerImage.getString())
        if bannerImageType == .One || bannerImageType == .Three {
            bannerDescription.textAlignment = .left
        } else {
            bannerDescription.textAlignment = .center
        }
    }
}
