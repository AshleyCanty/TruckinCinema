//
//  MovieDBMapper.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/4/24.
//

import Foundation


enum MovieItemMapper {
    static func map(data: Data, response: HTTPURLResponse, forMovieRequestType type: MovieRequestType) -> MovieLoader.Result {
        switch type {
        case .popularMovies:
            return decodeData(usingType: PopularMovies.self, data: data, response: response)
        case .singleMovie(_):
            return decodeData(usingType: Movie.self, data: data, response: response)
        case .movieTrailers(_):
            return decodeData(usingType: MovieTrailers.self, data: data, response: response)
        case .movieRatingAndReleaseDates(_):
            return decodeData(usingType: MovieReleaseDates.self, data: data, response: response)
        }
    }
    
    static func decodeData<T: Codable>(usingType type: T.Type, data: Data, response: HTTPURLResponse) -> MovieLoader.Result {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM d, yyyy"

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard response.statusCode == 200, let results = try? decoder.decode(type.self, from: data) else {
            return .failure(RemoteMovieLoader.Error.invalidData)
        }
        
        return .success(results)
    }
}
