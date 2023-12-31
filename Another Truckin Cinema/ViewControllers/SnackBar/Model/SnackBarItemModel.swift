//
//  Model.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 8/21/23.
//

import Foundation
import UIKit


struct SnackBarItemModel {
    let mainMenu: String
    var size: String
    let name: String
    let image: String
    let priceString: String
    let priceNumber: Double
    
    init(mainMenu: String, size: String = "", name: String, image: String, priceString: String, priceNumber: Double) {
        self.mainMenu = mainMenu
        self.size = size
        self.name = name
        self.image = image
        self.priceString = priceString
        self.priceNumber = priceNumber
    }
}

// MARK: - Main Menu Names & Images

enum SnackBarItemMain: String {
    case Popcorn = "Traditional Popcorn"
    case Beverages = "Beverages"
    case Snacks = "Snacks"
    
    func getStringVal() -> String { return self.rawValue }
    
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
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarPopcornImage: String, CaseIterable {
    case Traditional = "popcorn_traditional"
    case GourmetSingle = "popcorn_gourmetSingle"
    case GourmetDuo = "popcorn_gourmetDuo"
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarPopcornPrice: Double, CaseIterable {
    case Traditional = 9.09
    case GourmetSingle = 9.69
    case GourmetDuo = 11.69
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "$%.2f", self.rawValue) }
}
/// tradtitional popcorn prices enum
enum SnackBarTraditionalPopcornPrice: Double, CaseIterable {
    case small = 6.50
    case medium = 9.09
    case large = 11.69
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "$%.2f", self.rawValue) }
    
    func getSizeAndPriceStringVal() -> String {
        var size = ""
        switch self {
        case .small:
            size = "Small"
        case .medium:
            size = "Medium"
        case .large:
            size = "Large"
        }
        return String(format: "\(size) - $%.2f", self.rawValue)
    }
}
/// gourmet single popcorn prices enum
enum SnackBarGourmetSinglePopcornPrice: Double, CaseIterable {
    case small = 6.99
    case medium = 9.69
    case large = 12.15
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "$%.2f", self.rawValue) }
    
    func getSizeAndPriceStringVal() -> String {
        var size = ""
        switch self {
        case .small:
            size = "Small"
        case .medium:
            size = "Medium"
        case .large:
            size = "Large"
        }
        return String(format: "\(size) - $%.2f", self.rawValue)
    }
}
/// gourmet duo popcorn prices enum
enum SnackBarGourmetDuoPopcornPrice: Double, CaseIterable {
    case small = 7.20
    case medium = 11.69
    case large = 13.30
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "$%.2f", self.rawValue) }
    
    func getSizeAndPriceStringVal() -> String {
        var size = ""
        switch self {
        case .small:
            size = "Small"
        case .medium:
            size = "Medium"
        case .large:
            size = "Large"
        }
        return String(format: "\(size) - $%.2f", self.rawValue)
    }
}


// MARK: - Beverage

enum SnackBarBeverageImage: String, CaseIterable {
    case Small = "beverages_small"
    case Medium = "beverages_medium"
    case Large = "beverages_large"
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarBeverageOption: String, CaseIterable {
    case Small = "Small"
    case Medium = "Medium"
    case Large = "Large"
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarBeveragePrice: Double, CaseIterable {
    case Small = 5.80
    case Medium = 6.50
    case Large = 8.99
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "$%.2f", self.rawValue) }
}

// MARK: - Snacks

enum SnackBarSnackImage: String, CaseIterable {
    case MixedCandy = "snacks_mixed"
    case Nachos = "snacks_nachos"
    case PretzelBites = "snacks_pretzels"
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarSnackOption: String, CaseIterable {
    case MixedCandy = "Mixed Candy"
    case Nachos = "Nachos"
    case PretzelBites = "PretzelBites"
    func getStringVal() -> String { return self.rawValue }
}

enum SnackBarSnackPrice: Double, CaseIterable {
    case MixedCandy = 4.60
    case Nachos = 7.99
    case PretzelBites = 6.99
    
    func getDoubleVal() -> Double { return self.rawValue }
    func getStringVal() -> String { return String(format: "%.2f", self.rawValue) }
}

