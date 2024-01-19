//
//  ReleaseDates.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation




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
