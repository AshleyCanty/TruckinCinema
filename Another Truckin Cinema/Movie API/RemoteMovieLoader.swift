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
    
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        client.get(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data, let response):
                completion(.success([]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
