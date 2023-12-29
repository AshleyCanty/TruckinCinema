//
//  ThemeButton.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/19/23.
//

import Foundation
import UIKit

/// ThemeButton class
class ThemeButton: RoundedButton {
    
    struct Style {
        static let Height: CGFloat = 45
        static var TitleFont: UIFont = AppFont.semiBold(size: 15)
        static var ActiveBg: UIColor = AppColors.ButtonActive
        static var InactiveBg: UIColor = AppColors.ButtonInactive
        static var HighlightedBg: UIColor = AppColors.ButtonHighlighted
        static var ActiveTitleColor: UIColor = AppColors.ButtonTitleLabelActive
        static var InactiveTitleColor: UIColor = AppColors.ButtonTitleLabelInactive
        static var HighlightedTitleColor: UIColor = AppColors.ButtonTitleLabelHighlighted
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = Style.TitleFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setBackgroundImage(Style.ActiveBg.image(), for: .normal)
        setBackgroundImage(Style.InactiveBg.image(), for: .disabled)
        setBackgroundImage(Style.HighlightedBg.image(), for: .highlighted)
        
        setTitleColor(Style.ActiveTitleColor, for: .normal)
        setTitleColor(Style.InactiveTitleColor, for: .disabled)
        setTitleColor(Style.HighlightedTitleColor, for: .highlighted)
    }
}
