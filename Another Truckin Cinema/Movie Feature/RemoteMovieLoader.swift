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
    
//    func load(forRequestType movieRequestType: MovieDBRequestType, completion: @escaping (MovieLoader.Result) -> Void) {
//
//        guard let request = try? getMovieDBRequest(forType: movieRequestType) else {
//            completion(.failure(Error.invalidData))
//            return
//        }
//
//        Task {
//            await client.fetch(with: request) { [weak self] result in
//                guard let self = self else {
//                    return
//                }
//                switch result {
//                case .success(let jsonObjects):
//                    completion(.success(jsonObjects))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//
//            }
//        }
//    }
    
    func load<T: APIRequest>(forRequest request: T, completion: @escaping (MovieLoader.Result) -> Void) {

        Task {
            await client.fetch(with: request) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let jsonObjects):
                    completion(.success(jsonObjects))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
    }
    
    public func getMovieAccessoryUrl(for type: MovieAccessoryType) throws -> URL {
        guard let movieClient = client as? MovieDBClient else { throw Error.invalidData }
        return movieClient.getMovieAccessoryURL(forType: type)
    }
    
    private func getMovieDBRequest(forType type: MovieDBRequestType) throws -> any APIRequest {
        guard let movieClient = client as? MovieDBClient else { throw Error.invalidData }
        return movieClient.getMovieDBRequest(forType: type)
        
    }
}
