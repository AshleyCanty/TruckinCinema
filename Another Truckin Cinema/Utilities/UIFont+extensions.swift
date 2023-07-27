//
//  UIFont+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/9/23.
//

import Foundation
import UIKit

extension UIFont {
    /// A custom initializer that accepts a custom font and size
    convenience init?(customFont: CustomFont, size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}

