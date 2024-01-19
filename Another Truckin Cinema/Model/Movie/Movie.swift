//
//  MovieDetails.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation




struct Movie: Equatable, Codable {
    let backdropPath: String?
    let genres: [Genre]?
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let title: String?
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct MovieImages: Codable {
    let posters: [MoviePoster]
}

struct MoviePoster: Codable {
    let path: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "file_path"
    }
}
