//
//  Model.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit


struct SnackBarItemModel {
    let name: String
    let image: String
    let priceString: String
    let priceNumber: Double
}

// MARK: - Main Menu Names & Images

enum SnackBarItemMain: String {
    case Popcorn = "Traditional Popcorn"
    case Beverages = "Beverages"
    case Snacks = "Snacks"
    
    func getString() -> String { return self.rawValue }
    
    func getImage() -> String {
        switch self {
        case .Popcorn: return "popcorn_main"
        case .Beverages: return "beverages_main"
        case .Snacks: return "snacks_main"
        }
    }
}


// MARK: - Popcorn

enum SnackBarPopcornOption: String, CaseIterable {
    case Traditional = "Traditional Popcorn"
    case GourmetSingle = "Gourmet Single"
    case GourmetDuo = "Gourmet Duo"
    func getString() -> String { return self.rawValue }
}

enum SnackBarPopcornImage: String, CaseIterable {
    case Traditional = "popcorn_traditional"
    case GourmetSingle = "popcorn_gourmetSingle"
    case GourmetDuo = "popcorn_gourmetDuo"
    func getString() -> String { return self.rawValue }
}

enum SnackBarPopcornPrice: Int, CaseIterable {
    case Traditional
    case GourmetSingle
    case GourmetDuo
    
    func getDoubleValue() -> Double {
        switch self {
        case .Traditional: return 9.09
        case .GourmetSingle: return 9.69
        case .GourmetDuo: return 11.69
        }
    }
    
    func getString() -> String {
        switch self {
        case .Traditional: return "$9.09"
        case .GourmetSingle: return "$9.69"
        case .GourmetDuo: return "$11.69"
        }
    }
}


// MARK: - Beverage

enum SnackBarBeverageImage: String, CaseIterable {
    case Small = "beverages_small"
    case Medium = "beverages_medium"
    case Large = "beverages_large"
    func getString() -> String { return self.rawValue }
}

enum SnackBarBeverageOption: String, CaseIterable {
    case Small = "Small"
    case Medium = "Medium"
    case Large = "Large"
    func getString() -> String { return self.rawValue }
}

enum SnackBarBeveragePrice: CaseIterable {
    case Small
    case Medium
    case Large
    
    func getDoubleValue() -> Double {
        switch self {
        case .Small: return 5.80
        case .Medium: return 6.50
        case .Large: return 8.99
        }
    }
    
    func getString() -> String {
        switch self {
        case .Small: return "$5.80"
        case .Medium: return "$6.50"
        case .Large: return "$8.99"
        }
    }
}

// MARK: - Snacks

enum SnackBarSnackImage: String, CaseIterable {
    case MixedCandy = "snacks_mixed"
    case Nachos = "snacks_nachos"
    case PretzelBites = "snacks_pretzels"
    func getString() -> String { return self.rawValue }
}

enum SnackBarSnackOption: String, CaseIterable {
    case MixedCandy = "Mixed Candy"
    case Nachos = "Nachos"
    case PretzelBites = "PretzelBites"
    func getString() -> String { return self.rawValue }
}

enum SnackBarSnackPrice: CaseIterable {
    case MixedCandy
    case Nachos
    case PretzelBites
    
    func getDoubleValue() -> Double {
        switch self {
        case .MixedCandy: return 4.60
        case .Nachos: return 7.99
        case .PretzelBites: return 6.99
        }
    }
    
    func getString() -> String {
        switch self {
        case .MixedCandy: return "$4.60"
        case .Nachos: return "$7.99"
        case .PretzelBites: return "$6.99"
        }
    }
}

