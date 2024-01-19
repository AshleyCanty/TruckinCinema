//
//  APIError.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation

/// enum for APIError
enum APIError: Error {
    case requestFailed(description: String)
    case invalidURL
    case invalidData
    case responseUnsuccessful(description: String)
    case failedToDecode(description: String)
    case connectivity
    
    var customDescription: String {
        switch self {
        case .requestFailed(let description): return "Request Failed: \(description)"
        case .invalidData: return "Invalid Data"
        case .invalidURL: return "Invalid Url"
        case .responseUnsuccessful(description: let description): return "Unsuccessful: \(description)"
        case .failedToDecode(description: let description): return "JSON Decoding Failure: \(description)"
        case .connectivity: return "No internet connection"
        }
    }
}
