//
//  AppColors.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/5/23.
//

import Foundation
import UIKit

/// A struct for the app's colors
public struct AppColors {
    
    /// General
    static let BackgroundMain: UIColor = UIColor(hex: "#1F1D2B")
    static let BackgroundSecondary: UIColor = UIColor(hex: "#252837")
    static let BackgroundTertiary: UIColor = UIColor(hex: "#1F1F2C")
    static let RegularGray: UIColor = UIColor(hex: "#8D8D98")
    static let RegularTeal: UIColor = UIColor(hex: "#14CDDA")

    /// Buttons
    static let ButtonActive: UIColor = UIColor(hex: "#14CDDA")
    static let ButtonInactive: UIColor = UIColor(hex: "#14CDDA").withAlphaComponent(0.65)
    static let ButtonHighlighted: UIColor = UIColor(hex: "#14A0AA")
    static let ButtonTitleLabelActive: UIColor = UIColor(hex: "#ffffff")
    static let ButtonTitleLabelInactive: UIColor = UIColor(hex: "#ffffff").withAlphaComponent(0.65)
    static let ButtonTitleLabelHighlighted: UIColor = UIColor(hex: "#ffffff")
    
    /// Banner
    static let BannerSignupRibbonBackground: UIColor = UIColor(hex: "FEAC66")
    static let BannerCollectionBGColor: UIColor = UIColor(hex: "1A1824")
    static let CurrentPageIndicatorTintColor: UIColor = UIColor.white.withAlphaComponent(0.80)
    static let PageIndicatorTintColor: UIColor = UIColor.white.withAlphaComponent(0.40)
    
    /// Homescreen
    static let DateLabelTextColor: UIColor = UIColor(hex: "C5C5C5")
    
    /// MovieDetails
    static let MovieDetailsTextColorPrimary: UIColor = UIColor.white
    static let MovieDetailsTextColorSecondary: UIColor = UIColor(hex: "A6A6A6")
    
    /// Custom Segmented Control
    /// /// MovieDetails
    static let SegmentedControlTextColor: UIColor = UIColor(hex: "A6A6A6")
    static let SegmentedControlSelectedTextColor: UIColor = .white
    static let SegmentedControlHighlightedBgColor: UIColor = UIColor(hex: "333333")
}

struct AppTheme {

    /// Placeholder image name
    static let ImagePlaceholder: String = "placeholder"
    
    /// Margin values
    static let LeadingTrailingMargin: CGFloat = 12
    static let BottomMargin: CGFloat = 12
    
    /// Shadow styling
    static let ShadowColor: UIColor = .black
    static let ShadowOpacity: Float = 0.08
    static let ShadowRadius: CGFloat = 6
    static let ShadowOffset: CGSize = CGSize(width: 0, height: 0)
}

