//
//  UIImage+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/10/23.
//

import Foundation
import UIKit


extension UIImage {

    /// A convenience init method used with images found in assets folder
    convenience init(imgNamed: String) {
        self.init(named: imgNamed)!
    }
}
