//
//  UIView+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/14/23.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// Custom method that adds multiple subviews
    func addSubviews(subviews: [UIView]) {
        subviews.forEach { view in
            self.addSubview(view)
        }
    }
    
    /// custom method to add shadow
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
}

extension CAGradientLayer {
    /// Assigns param to gradient color property, and assigns default values to startPoint and endPoint for vertical display.
    public func setVerticalGradient(withColors colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}