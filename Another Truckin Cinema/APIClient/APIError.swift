//
//  APIError.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation

/// enum for APIError
enum APIError: Error {
    case responseUnsuccessful(description: String)
    case connectivity
    
    var customDescription: String {
        switch self {
        case .responseUnsuccessful(description: let description): return "Unsuccessful: \(description)"
        case .connectivity: return "No internet connection"
        }
    }
}
