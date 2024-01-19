//
//  Trailers.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation




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
