//
//  DateView.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/16/23.
//

import Foundation
import UIKit


class DateView: UIView {
    /// Style struct
    struct Style {
        static let DataLabeltextColor: UIColor = AppColors.DateLabelTextColor
        static let DataLabelFont: UIFont = AppFont.semiBold(size: 12)
        static let DataLabelInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        static let DateLabelBackgroundColor: UIColor = AppColors.BackgroundSecondary
    }
    
    /// date label
    fileprivate lazy var dateLabel: UILabel = {
        let label = PaddedLabel()
        let insets = Style.DataLabelInsets
        label.padding(insets.top, insets.bottom, insets.left, insets.right)
        label.textColor = Style.DataLabeltextColor
        label.font = Style.DataLabelFont
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.layer.backgroundColor = Style.DateLabelBackgroundColor.cgColor
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height = contentSize.height + dateLabel.intrinsicContentSize.height
            contentSize.width = contentSize.width + dateLabel.intrinsicContentSize.width
            return contentSize
        }
        
    }
    
    convenience init(date: String) {
        self.init(frame: .zero)
        setup(withDate: date)
    }
    
    fileprivate func setup(withDate date: String) {
        addShadow(color: AppTheme.ShadowColor, opacity: AppTheme.ShadowOpacity, radius: AppTheme.ShadowRadius, offset: AppTheme.ShadowOffset)
        backgroundColor = .clear
        
        dateLabel.text = date
        addSubview(dateLabel)
        
        dateLabel.disableTranslatesAutoresizingMaskIntoContraints()
        dateLabel.tc_constrainToSuperview()
        layoutSubviews()
    }
    
}
