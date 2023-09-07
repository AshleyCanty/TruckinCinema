//
//  RadioButton.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/9/23.
//

import Foundation
import UIKit

/// RadioButton class
class RadioButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1
                return
            }
            self.alpha = 0.3
        }
    }
}
