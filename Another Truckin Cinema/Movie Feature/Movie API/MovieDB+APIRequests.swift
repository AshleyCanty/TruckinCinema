//
//  MovieDB+APIRequests.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation


// API Request - Popular Movies
struct GetPopularMovies: APIRequest {
    typealias Response = PopularMovies

    var headers: [String: String] = MovieDBClient.headers
    var paths: [String] = ["popular"]
    var queryItems: [String : String] = ["language": "en", "page": "1"]
    
    func url() -> URL? {
        return MovieDBEndpoint.endpoint(for: self)
    }
}

// API Request - Single Movie
struct GetMovie: APIRequest {
    typealias Response = Movie
    
    var headers: [String: String] = MovieDBClient.headers
    var paths: [String]
    var queryItems: [String : String] = [:]
    
    init(paths: [String] = []) {
        self.paths = paths
    }
    
    func url() -> URL? {
        return MovieDBEndpoint.endpoint(for: self)
    }
}

// API Request - Movie Trailers
struct GetMovieTrailers: APIRequest {
    typealias Response = MovieTrailers
    
    var headers: [String: String] = MovieDBClient.headers
    var paths: [String]
    var queryItems: [String : String] = [:]
    
    init(paths: [String] = []) {
        self.paths = paths
    }
    
    func url() -> URL? {
        return MovieDBEndpoint.endpoint(for: self)
    }
}

// API Request - Movie Release Dates
struct GetMovieReleaseDates: APIRequest {
    typealias Response = MovieReleaseDates

    var headers: [String: String] = MovieDBClient.headers
    var paths: [String]
    var queryItems: [String : String] = ["language": "en", "append_to_response": "release_dates"]
    
    init(paths: [String] = []) {
        self.paths = paths
    }
    
    func url() -> URL? {
        return MovieDBEndpoint.endpoint(for: self)
    }
}
