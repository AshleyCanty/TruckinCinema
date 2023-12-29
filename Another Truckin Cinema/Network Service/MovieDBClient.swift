//
//  MovieDBClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation


//protocol MovieClient

final class MovieDBClient: GenericAPI {
    private let youtubeBaseUrl: URL = URL(string: "http://www.youtube.com/v")! /// https://developers.google.com/youtube/iframe_api_reference
    
    private let baseURL: URL = URL(string: "https://api.themoviedb.org/3/movie")!
    private let imageBaseUrl = URL(string: "https://image.tmdb.org/t/p/original/")!
    private let apiKey = "d781149385cbb34069c2a866eac35a30"
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNzgxMTQ5Mzg1Y2JiMzQwNjljMmE4NjZlYWMzNWEzMCIsInN1YiI6IjY0YTRhYzBjOGM0NGI5MDEyZDZiOTMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jexcRRrax-HS91ElbcQlu1Xnf8_yp97WgjUjvEQeVJk"
    
    /// Returns a youtube url for the trailer's video key
    public func createTrailerUrl(videoKey: String) -> URL {
        // /VIDEO_ID?version=3
        var trailerUrl = youtubeBaseUrl.appending(path: videoKey)
        trailerUrl.append(queryItems: [URLQueryItem(name: "version", value: "3")])
        return trailerUrl
    }
    
    private let trailerThumbnailBaseUrl: URL = URL(string: "https://i.ytimg.com/vi")!
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Fetches popular movies
    public func fetchPopularMovies() async throws -> PopularMovies {
        try await prepareFetch(type: PopularMovies.self,
                                            paths: ["popular"],
                                            queryItems: [URLQueryItem(name: "language", value: "en"), URLQueryItem(name: "page", value: "1")])
    }
    
    /// Fetches a movie
    public func fetchMovie(withId id: String) async throws -> MovieDetails {
        try await prepareFetch(type: MovieDetails.self, paths: [id])
    }
    
    /// Fetches movie trailers
    public func fetchMovieTrailers(withId id: String) async throws -> MovieTrailers {
        try await prepareFetch(type: MovieTrailers.self, paths: [id, "videos"])
    }
    
    /// Fetch release dates and ratings
    public func fetchRatingAndReleaseDates(withId id: String) async throws -> MovieReleaseDates {
        try await prepareFetch(type: MovieReleaseDates.self, paths: [id],
                                             queryItems: [URLQueryItem(name: "language", value: "en"),
                                                          URLQueryItem(name: "append_to_response", value: "release_dates")])
    }
    
//    /// Fetches movie trailers
//    public func fetchMoviePosters(withId id: String) async throws -> [MoviePoster] {
//        let result = try await prepareFetch(type: MovieImages.self, paths: [id, "images"])
//        return result.posters
//    }
//    
    /// Returns url for poster
    public func createImageUrl(with posterPath: String) -> URL {
        imageBaseUrl.appending(path: posterPath.replacingOccurrences(of: "/", with: ""))
    }
    
    /// Returns url for trailer's thumbnail image
    public func createTrailerThumbnailUrl(withKey key: String) -> URL {
        trailerThumbnailBaseUrl.appending(path: key).appending(path: "hqdefault.jpg")
    }
    
    /// Prepares network request by accepting params: codable type, paths, and query items
    fileprivate func prepareFetch<T: Codable>(type: T.Type, paths: [String]?, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let paths = paths else { throw APIError.invalidURL }
        
        /// Append paths to baseURL
        var movieDatabaseUrl = baseURL
        paths.forEach({ movieDatabaseUrl = movieDatabaseUrl.appendingPathComponent($0) })
        
        /// Add query items
        var urlComponents = URLComponents(string: movieDatabaseUrl.absoluteString)
        urlComponents?.queryItems = queryItems
        
        /// Add header fields
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "authorization")
        
        let result = try await fetch(type: T.self, with: request)
        return result
    }
}
