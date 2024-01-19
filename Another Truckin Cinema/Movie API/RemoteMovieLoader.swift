//
//  RemoteMovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


final class RemoteMovieLoader: MovieLoader {
    let client: HTTPClient
    
    enum Error: Swift.Error {
        case invalidUrl
        case invalidData
        case connectivity
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(forRequestType movieRequestType: MovieRequestType, completion: @escaping (MovieLoader.Result) -> Void) {
        guard let client = client as? MovieDBClient, let url = try? client.getMovieRequestUrl(forType: movieRequestType) else {
            completion(.failure(Error.invalidData))
            return
        }
        
        Task {
            let result = try await client.processFetch(withUrl: url)
            switch result {
            case .success((let data, let response)):
                guard response.statusCode == 200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                completion(MovieItemMapper.map(data: data, response: response, forMovieRequestType: movieRequestType))
            case .failure(_):
                completion(.failure(Error.invalidData))
                return
            }
        }
    }
}
