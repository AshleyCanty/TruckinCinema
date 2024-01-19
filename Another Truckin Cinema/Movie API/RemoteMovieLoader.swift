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
    let movieRequestType: MovieRequestType
    
    enum MovieRequestType {
        case popularMovies(String)
        case movieDetails
        case movieTrailers(String)
        case movieRatingAndReleaseDates(String)
    }
    
    enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
    
    init(url: URL, client: HTTPClient, movieRequestType: MovieRequestType) {
        self.url = url
        self.client = client
        self.movieRequestType = movieRequestType
    }
    
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        client.get(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data, let response):
                guard response.statusCode == 200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                completion(.success([]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}



