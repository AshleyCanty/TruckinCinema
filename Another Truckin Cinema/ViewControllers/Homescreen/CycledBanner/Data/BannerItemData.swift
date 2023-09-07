//
//  BannerItemData.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/10/23.
//

import Foundation
import UIKit

/// BannerImageName enum
public enum BannerImage: String, CaseIterable {
    case SignUp = "banner-signup"
    case One = "banner-1"
    case Two = "banner-2"
    case Three = "banner-3"
    
    func getString() -> String {
        return self.rawValue
    }
}

/// BannerDescription enum
public enum BannerDescription: String {
    case SignUp = "Join our Truckin’ Cinema VIP membership to receive special discounts."
    case One = "Don’t want to sit in your car? We also sell camping chairs by the snack bar. Come by!"
    case Two = "Buy One, Get One FREE deal on all Beef Hotdogs this weekend!"
    case Three = "Please remember to always keep your headlights off until the movie is done."
    
    func getString() -> String {
        return self.rawValue
    }
}

/// BannerIcon enum
public enum BannerIcon: String {
    case SignUp = "icon-signup"
    case One = "1"
    case Two = "2"
    case Three = "3"
    
    /// Returns string value of case
    func getString() -> String {
        return self.rawValue
    }
}

/// BannerType enum
public enum BannerType {
    case SignUp
}
