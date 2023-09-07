//
//  RoundedButton.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/14/23.
//

import Foundation
import UIKit

/// RoundedButton class
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}

