//
//  SnackBarItem.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation


/// SnackBarItem protocol
protocol SnackBarItem {
    var title: String { get set }
    var price: Double { get set }
    var size: String { get set }
}

/// enum for snack item size
enum SnackItemSize: Int {
    case small, medium, large
    
    func getStringVal() -> String {
        switch self {
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        }
    }
}
