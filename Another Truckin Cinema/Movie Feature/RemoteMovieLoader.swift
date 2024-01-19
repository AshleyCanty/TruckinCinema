//
//  RemoteMovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


final class RemoteMovieLoader: MovieLoader {
    
    let client: APIClient
    
    enum Error: Swift.Error {
        case invalidUrl
        case invalidData
        case connectivity
    }
    
    init(client: APIClient) {
        self.client = client
    }
    
    func load(with endpoint: MovieAPI.GET, completion: @escaping (MovieLoader.Result) -> Void) async throws {
        
        guard let url = endpoint.url else { throw Error.invalidUrl }

        await client.fetch(withUrl: url, headers: MovieDBClient.headers(), completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success((let data, let response)):
                completion(MovieItemMapper.map(forMovieEndpointType: endpoint, data: data, response: response))
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        })
    }
}

