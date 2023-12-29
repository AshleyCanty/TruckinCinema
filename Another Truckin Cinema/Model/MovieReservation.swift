//
//  MovieReservation.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation

struct MovieReservation: Codable, Identifiable {
    let id: String = UUID().uuidString
    var date: String
    var car: Car
    var customer: Customer
    var location: String
    var tickets: Tickets
    var reservedMovieDetails: ReservedMovieDetails
    var foodOrder: FoodOrder?
    
    init(date: String = "",
         location: String = "",
         car: Car = Car(),
         customer: Customer = Customer(),
         tickets: Tickets = Tickets(),
         reservedMovieDetails: ReservedMovieDetails = ReservedMovieDetails(movieTitle: "", duration: "", rating: ""),
         foodOrder: FoodOrder? = nil) {
        self.date = date
        self.car = car
        self.customer = customer
        self.location = location
        self.tickets = tickets
        self.reservedMovieDetails = reservedMovieDetails
        self.foodOrder = foodOrder
    }
    
    func calculateTotalOrderCost() -> Double {
        let ticketCost = tickets.calculateTotalPrice()
//        let snackbarCost =
        let total = ticketCost
        return total
    }
}

// ------

struct ReservedMovieDetails: Codable {
    var movieTitle: String
    var duration: String
    var rating: String
    var screen: Screen?
}

struct Screen: Codable {
    var id: Int // 0 for first screen, 1 for second screen
    var viewingOrder: Int // 0 for first movie, 1 for second movie
    var showtime: Int // 0 for 8:30pm, 1 for 11:30pm
    
    init(id: Int = 0, viewingOrder: Int = 0, showtime: Int = 0) {
        self.id = id
        self.viewingOrder = viewingOrder
        self.showtime = showtime
    }
}


