//
//  UIView+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/14/23.
//

import Foundation
import UIKit

extension UIView {
    /// Returnd width of app's window inside the window scene
    func getwindowSceneWidth() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let width = window?.screen.bounds.width ?? 0
        return width
    }
    
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
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
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
