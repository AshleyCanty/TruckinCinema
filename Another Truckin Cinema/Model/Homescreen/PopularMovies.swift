//
//  PopularMovies.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/17/23.
//

import Foundation


struct PopularMovies: Codable {
    let results: [Movie]?
}

struct Movie: Codable {
    let id: Int?
    let posterPath: String?
    let title: String?
}
