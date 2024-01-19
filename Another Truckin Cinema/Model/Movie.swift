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

struct MovieTrailers: Codable {
    let results: [Trailer]?
}

struct Trailer: Codable {
    let name: String?
    let key: String?
    let site: String?
    let official: Bool?
    let publishedAt: String?
    let type: String? // teaser, clip, featurette
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


struct MovieReleaseDates: Codable {
    let releaseDates: MovieReleaseResults
    
    func filterForUSRating() -> String {
        let usLocations = releaseDates.results.filter { $0.iso == "US" }.first
        let ratingElement = usLocations?.releaseDates?.filter { $0.certification?.count ?? 0 > 0 }.first
        return ratingElement?.certification ?? ""
    }
}

struct MovieReleaseResults: Codable {
    let results: [MovieReleaseInfo]
}

struct MovieReleaseInfo: Codable {
    let iso: String?
    let releaseDates: [MovieRating]?
    
    enum CodingKeys: String, CodingKey {
        case iso = "iso31661"
        case releaseDates
    }
}

struct MovieRating: Codable {
    let certification: String?
}

