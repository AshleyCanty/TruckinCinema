//
//  MovieShowtime+Enums.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/24/23.
//

import Foundation


/// Identifies which screen the movie will play on: Screen One or Two
enum MovieScreenId: Int {
    case first, second
    func getStringVal() -> String {
        switch self {
        case .first: return "One"
        case .second: return "Two"
        }
    }
}

enum MovieViewingOrder: Int {
    case first, second
    func getStringVal() -> String {
        switch self {
        case .first: return "First"
        case .second: return "Second"
        }
    }
}

enum MovieShowtime: Int {
    case first, second
    func getStringVal() -> String {
        switch self {
        case .first: return "8:30pm"
        case .second: return "11:30pm"
        }
    }
}
