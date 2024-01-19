//
//  MovieDBClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation



final class MovieDBClient: APIClient {
    
    static let headers = [
        "apiKey": MovieDBClient.apiKey,
        "authorization": "Bearer \(MovieDBClient.bearerToken)"
    ]
    
    static let apiKey = "d781149385cbb34069c2a866eac35a30"
    static let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNzgxMTQ5Mzg1Y2JiMzQwNjljMmE4NjZlYWMzNWEzMCIsInN1YiI6IjY0YTRhYzBjOGM0NGI5MDEyZDZiOTMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jexcRRrax-HS91ElbcQlu1Xnf8_yp97WgjUjvEQeVJk"
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }

    func getMovieDBRequest(forType type: MovieDBRequestType) -> any APIRequest {
        switch type {
        case .popularMovies:
            return GetPopularMovies()
        case .singleMovie(let id):
            return GetMovie(paths: [id])
        case .movieTrailers(let id):
            return GetMovieTrailers(paths: [id, "videos"])
        case .movieRatingAndReleaseDates(let id):
            return GetMovieReleaseDates(paths: [id])
        }
    }

    func getMovieAccessoryURL(forType type: MovieAccessoryType) -> URL {
        switch type {
        case .poster(let path):
            return MovieDBEndpoint.getPosterUrl(with: path)
        case .trailer(let key):
            return MovieDBEndpoint.getTrailerUrl(with: key)
        case .trailerThumbnail(let key):
            return MovieDBEndpoint.getTrailerThumbnailUrl(with: key)
        }
    }
}
