//
//  PopularMovies.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/17/23.
//

import Foundation


struct PopularMovies: Codable, Hashable {
    let results: [PopularMovie]?
    static func == (lhs: PopularMovies, rhs: PopularMovies) -> Bool {
        if let lhsResults = lhs.results, let rhsResults = rhs.results {
            return lhsResults == rhsResults
        }
        return false
    }
}

struct PopularMovie: Codable, Hashable {
    let id: Int?
    let posterPath: String?
    let title: String?
}
