//
//  AutoLayout+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/13/23.
//

import Foundation
import UIKit

// Note** The "tc_" prefix merely just acts as a reference the app name "Truckin Cinema", to make clear that it's a custom method :D

/// NSLayoutAnchor extension holding custom methods
extension NSLayoutAnchor {
    /// Method that automatically activates a constraint and adds the provided constant
    @objc func tc_constrain(equalTo anchor: NSLayoutAnchor, constant: CGFloat) {
        self.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(equalTo anchor: NSLayoutAnchor) {
        self.constraint(equalTo: anchor).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(lessThanOrEqualTo anchor: NSLayoutAnchor) {
        self.constraint(lessThanOrEqualTo: anchor).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(lessThanOrEqualTo anchor: NSLayoutAnchor, constant: CGFloat) {
        self.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(greaterThanOrEqualTo anchor: NSLayoutAnchor) {
        self.constraint(greaterThanOrEqualTo: anchor).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(greaterThanOrEqualTo anchor: NSLayoutAnchor, constant: CGFloat) {
        self.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
    }
}

extension NSLayoutDimension {
    /// Method that automatically activates a constraint
    @objc func tc_constrain(equalToConstant constant: CGFloat) {
        self.constraint(equalToConstant: constant).isActive = true
    }
    
    @objc func tc_constrain(equalTo anchor: NSLayoutDimension, multiplier: CGFloat) {
        self.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
    }
    
    @objc func tc_constrain(equalTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
        self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(lessThanOrEqualToConstant constant: CGFloat) {
        self.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }
    
    
    /// Method that automatically activates a constraint
    @objc func tc_constrain(greaterThanOrEqualToConstant constant: CGFloat) {
        self.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
    
    @objc func tc_constrain(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
        self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).isActive = true
    }
}

extension UIView {
    /// Custom method that sets the "TranslateAutoresizingMaskIntoContraints" property to false
    func disableTranslatesAutoresizingMaskIntoContraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Custom method that constraints a view to all anchors of its superview, if it exists
    func tc_constrainToSuperview() {
        guard let superview = self.superview else { return }
        
        self.topAnchor.tc_constrain(equalTo: superview.topAnchor)
        self.bottomAnchor.tc_constrain(equalTo: superview.bottomAnchor)
        self.leadingAnchor.tc_constrain(equalTo: superview.leadingAnchor)
        self.trailingAnchor.tc_constrain(equalTo: superview.trailingAnchor)
    }
    
    /// Custom method that constraints a view to all anchors of the specified view
    func tc_constrainToEdges(view: UIView) {
        self.topAnchor.tc_constrain(equalTo: view.topAnchor)
        self.bottomAnchor.tc_constrain(equalTo: view.bottomAnchor)
        self.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor)
        self.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor)
    }
    
    /// Custom method that constraints a view to all anchors of the specified view with constants: top, bottom leading, trailing
    func tc_constrainToEdgesWithMargins(view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.topAnchor.tc_constrain(equalTo: view.topAnchor, constant: top)
        self.bottomAnchor.tc_constrain(equalTo: view.bottomAnchor, constant: bottom)
        self.leadingAnchor.tc_constrain(equalTo: view.leadingAnchor, constant: leading)
        self.trailingAnchor.tc_constrain(equalTo: view.trailingAnchor, constant: trailing)
    }
}
