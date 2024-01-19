//
//  FoodOrder.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation


struct FoodOrder: Codable {
    var customerEmail: String?
    var purchaseId: String? // Use same id for ticket purchase too
    var candy: [Candy]?
    var popcorn: [Popcorn]?
    var drink: [Drink]?
    var deliveryDetails: FoodDeliveryDetails?
    
    init(customerEmail: String? = nil, purchaseId: String? = nil, candy: [Candy]? = [], popcorn: [Popcorn]? = [], drink: [Drink]? = [], deliveryDetails: FoodDeliveryDetails? = nil) {
        self.customerEmail = customerEmail
        self.purchaseId = purchaseId
        self.candy = candy
        self.popcorn = popcorn
        self.drink = drink
        self.deliveryDetails = deliveryDetails
    }
    
    func getTotalCost() -> Double {
        var sum: Double = 0
        candy?.forEach({ sum += $0.price })
        popcorn?.forEach({ sum += $0.price })
        drink?.forEach({ sum += $0.price })
        return sum
    }
}

struct FoodDeliveryDetails: Codable {
    var car: Car
    var seat: String // driver or passenger
    var recipient: String
    var date: String
    var screen: Screen
}

struct Candy: Codable, SnackBarItem {
    var title: String
    var price: Double
    var size: String
}

struct Popcorn: Codable, SnackBarItem {
    var title: String
    var price: Double
    var size: String
}

struct Drink: Codable, SnackBarItem {
    var title: String
    var price: Double
    var size: String
}
