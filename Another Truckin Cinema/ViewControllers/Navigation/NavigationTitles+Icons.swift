//
//  NavigationTitles+Icons.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/12/23.
//

import Foundation
import UIKit


/// This file is for organizing Navigation elements

/// enum for image/icon names
public enum NavigationIcon: String {
    case MenuButton = "menu"
    case CloseButton = "close-btn"
    case BackButton = "back-btn"

    func getString() -> String { return self.rawValue }
}

/// enum for Navigation titles
public enum NavigationTitle: String {
    case NowPlaying = "Now Playing"
    case OurDriveIns = "Our Drive-ins"
    case FoodAndDrinks = "Food & Drinks"
    case MyATCMembership = "My ATC Membership"
    
    case DeliveryOrPickup = "Delivery to Car or Pickup at Snackbar"
    
    func getString() -> String { return self.rawValue }
}

/// Enum for TabBar icons
public enum TabBarIcon: String {
    case HomeInactive = "home-inactive"
    case Home = "home"
    case OurDriveInsInactive = "ourDriveIns-inactive"
    case OurDriveIns = "ourDriveIns"
    case FoodAndDrinksInactive = "foodAndDrink-inactive"
    case FoodAndDrinks = "foodAndDrink"
    case MembershipInactive = "membership-inactive"
    case Membership = "membership"
    
    func getString() -> String { return self.rawValue }
}

/// Enum for TabBar item titles
public enum TabBarItemTitle: String {
    case Home = "Now Playing"
    case OurDriveIns = "Our Drive-ins"
    case FoodAndDrinks = "Food & Drinks"
    case Membership = "Membership"
    func getString() -> String { return self.rawValue }
}
