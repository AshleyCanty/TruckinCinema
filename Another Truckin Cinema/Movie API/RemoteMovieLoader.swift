//
//  RemoteMovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


final class RemoteMovieLoader: MovieLoader {
    let url: URL
    let client: HTTPClient
    let movieUrlType: MovieUrlType
    
    enum MovieUrlType {
        case popularMovies
        case movieDetails(String)
        case movieTrailers(String)
        case movieRatingAndReleaseDates(String)
    }
    
    enum Error: Swift.Error {
        case invalidUrl
        case invalidData
        case connectivity
    }
    
    init(url: URL, client: HTTPClient, movieUrlType: MovieUrlType = .popularMovies) {
        self.url = url
        self.client = client
        self.movieUrlType = movieUrlType
    }
    
    func load<T: Codable>(forType type: T.Type, completion: @escaping (MovieLoader.Result) -> Void) {
        Task {
            let result = try await client.processFetch(withUrl: url, forType: type.self)
            print()
            
        }
        
        
        
//        let url =
//        client.get(with: URL(string:"")!) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data, let response):
//                guard response.statusCode == 200 else {
//                    completion(.failure(Error.invalidData))
//                    return
//                }
//                completion(MovieItemMapper.map(data: data, response: response, type: Movie.self))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}

enum MovieDBMapper {
    static func map<T: Codable>(data: Data, response: HTTPURLResponse, type: T.Type) throws -> T {
        guard response.statusCode == 200, let results = try? createDecoder().decode(type.self, from: data) else {
            throw RemoteMovieLoader.Error.invalidData
        }
        return results
    }
    
    static func createDecoder() throws -> JSONDecoder // T where T : Decodable
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM d, yyyy"

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}



