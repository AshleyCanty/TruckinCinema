//
//  MovieDBClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation


//protocol MovieClient

final class MovieDBClient: HTTPClient {
    private let youtubeBaseUrl: URL = URL(string: "http://www.youtube.com/v")! /// https://developers.google.com/youtube/iframe_api_reference
    
    private let baseURL: URL = URL(string: "https://api.themoviedb.org/3/movie")!
    private let imageBaseUrl = URL(string: "https://image.tmdb.org/t/p/original/")!
    private let apiKey = "d781149385cbb34069c2a866eac35a30"
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNzgxMTQ5Mzg1Y2JiMzQwNjljMmE4NjZlYWMzNWEzMCIsInN1YiI6IjY0YTRhYzBjOGM0NGI5MDEyZDZiOTMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jexcRRrax-HS91ElbcQlu1Xnf8_yp97WgjUjvEQeVJk"
    
    /// Returns a youtube url for the trailer's video key
    public func getTrailerUrl(videoKey: String) -> URL {
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
    private func getPopularMoviesURL() throws -> URL { //PopularMovies
        return try createURL(usingPaths: ["popular"],
                            queryItems: [URLQueryItem(name: "language", value: "en"), URLQueryItem(name: "page", value: "1")])
    }
    
    /// Fetches a movie
    private func getMovieURL(withId id: String) throws -> URL { // Movie {
        return try createURL(usingPaths: [id])
    }
    
    /// Fetches movie trailers
    private func getMovieTrailers(withId id: String) throws -> URL { //MovieTrailers {
        return try createURL(usingPaths: [id, "videos"])
    }
    
    /// Fetch release dates and ratings
    private func getRatingAndReleaseDates(withId id: String) throws -> URL { // MovieReleaseDates {
        return try createURL(usingPaths: [id],
                                queryItems: [URLQueryItem(name: "language", value: "en"),
                                             URLQueryItem(name: "append_to_response", value: "release_dates")])
    }
    
//    /// Fetches movie trailers
//    public func fetchMoviePosters(withId id: String) async throws -> [MoviePoster] {
//        let result = try await prepareFetch(forType: MovieImages.self, paths: [id, "images"])
//        return result.posters
//    }
//
    
    public func getMovieRequestUrl(forType type: MovieRequestType) throws -> URL {
        switch type {
        case .popularMovies:
            return try getPopularMoviesURL()
        case .singleMovie(let id):
            return try getMovieURL(withId: id)
        case .movieTrailers(let id):
            return try getMovieTrailers(withId: id)
        case .movieRatingAndReleaseDates(let id):
            return try getRatingAndReleaseDates(withId: id)
        }
    }
    
    /// Returns url for poster
    public func getImageUrl(with posterPath: String) -> URL {
        imageBaseUrl.appending(path: posterPath.replacingOccurrences(of: "/", with: ""))
    }
    
    /// Returns url for trailer's thumbnail image
    public func getTrailerThumbnailUrl(withKey key: String) -> URL {
        trailerThumbnailBaseUrl.appending(path: key).appending(path: "hqdefault.jpg")
    }
    
    func processFetch(withUrl url: URL) async throws -> HTTPClient.Result {
        let request = try createRequest(withUrl: url)
        return try await fetch(with: request)
    }

    private func createRequest(withUrl url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "authorization")
        return request
    }
    
    private func createURL(usingPaths paths: [String]?, queryItems: [URLQueryItem] = []) throws -> URL {
        guard let paths = paths else { throw APIError.invalidURL }
        
        /// Append paths to baseURL
        var movieDatabaseUrl = baseURL
        paths.forEach({ movieDatabaseUrl = movieDatabaseUrl.appendingPathComponent($0) })
        
        /// Add query items
        var urlComponents = URLComponents(string: movieDatabaseUrl.absoluteString)
        urlComponents?.queryItems = queryItems
        
        /// Add header fields
        guard let url = urlComponents?.url else { throw APIError.invalidURL }
        return url
    }
}
