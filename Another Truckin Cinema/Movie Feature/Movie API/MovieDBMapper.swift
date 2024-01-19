//
//  MovieDBMapper.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/4/24.
//

import Foundation


enum MovieItemMapper {
    static func map(forMovieEndpointType type: MovieAPI.GET, data: Data, response: HTTPURLResponse) -> MovieLoader.Result {
        
        guard response.statusCode == 200 else { return .failure(RemoteMovieLoader.Error.invalidData) }
        
        switch type {
        case .popularMovies:
            return decodeData(usingType: PopularMovies.self, data: data, response: response)
        case .movie(_):
            return decodeData(usingType: Movie.self, data: data, response: response)
        case .allTrailers(_):
            return decodeData(usingType: MovieTrailers.self, data: data, response: response)
        case .releaseDates(_):
            return decodeData(usingType: MovieReleaseDates.self, data: data, response: response)
        default:
            return .failure(RemoteMovieLoader.Error.invalidData)
        }
    }
    
    static func decodeData<T: Decodable>(usingType type: T.Type, data: Data, response: HTTPURLResponse) -> MovieLoader.Result {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM d, yyyy"

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let results = try? decoder.decode(type.self, from: data) else {
            return .failure(RemoteMovieLoader.Error.invalidData)
        }
        
        return .success(results)
    }
}
