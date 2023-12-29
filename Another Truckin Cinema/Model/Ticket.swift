//
//  Ticket.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation

/// struct for tickets
struct Tickets: Codable {
    let individualPrice: Double = 12.50
    var quantity: Int
    var qrCodeUrl: String
    var purchaseId: String
    
    init(quantity: Int = 0, qrCodeUrl: String = "", purchaseId: String = "") {
        self.quantity = quantity
        self.qrCodeUrl = qrCodeUrl
        self.purchaseId = purchaseId
    }
    
    func calculateTotalPrice() -> Double {
        return Double(quantity) * individualPrice
    }

    func getTotalPriceStringVal() -> String {
        return String(format: "$%.2f", self.calculateTotalPrice())
    }
}
