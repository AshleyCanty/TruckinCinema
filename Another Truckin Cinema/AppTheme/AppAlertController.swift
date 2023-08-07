//
//  AppAlertController.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/6/23.
//

import Foundation
import UIKit

class AppAlertController: UIAlertController {
    /// Create and return alert to cancel order
    static func createAlertToCancelOrder(handlerActionNo: ((UIAlertAction) -> ())?, handlerActionYes: ((UIAlertAction) -> ())?) -> UIAlertController {
        let alert = UIAlertController(title: "Cancel Order", message: "Are you sure you want to cancel your order?", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .default, handler: handlerActionNo)
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: handlerActionYes)
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        return alert
    }
}
