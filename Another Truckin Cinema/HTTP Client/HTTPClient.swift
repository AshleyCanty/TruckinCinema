//
//  HTTPClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    var session: URLSession { get }
//    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T
    func processFetch(withUrl url: URL) async throws -> Result
}

extension HTTPClient {
    func fetch(with request: URLRequest) async throws -> HTTPClient.Result {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.requestFailed(description: "Invalid response"))
        }
        
        return .success((data, httpResponse))
    }
}
