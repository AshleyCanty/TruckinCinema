//
//  NetworkManager.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/16/23.
//

import Foundation
import Combine


protocol GenericAPI {
    var session: URLSession { get }
    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T
}


extension GenericAPI {
    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid response")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MMM d, yyyy"

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.failedToDecode(description: error.localizedDescription)
        }
    }
}


struct RemoteFile<T: Decodable> {
    let url: URL
    let type: T.Type
    let apiKey = "d781149385cbb34069c2a866eac35a30"
    let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNzgxMTQ5Mzg1Y2JiMzQwNjljMmE4NjZlYWMzNWEzMCIsInN1YiI6IjY0YTRhYzBjOGM0NGI5MDEyZDZiOTMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jexcRRrax-HS91ElbcQlu1Xnf8_yp97WgjUjvEQeVJk"
    
    var contents: T {
        get async throws {
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "apiKey")
            request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "authorization")
            let (data, _) = try await URLSession.shared.data(for: request)

            // Decode JSON data into MovieResponse object
            let dateFormattwr = DateFormatter()
            dateFormattwr.dateFormat = "yyyy-mm-dd"
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(dateFormattwr)

            return try decoder.decode(T.self, from: Data(data))
        }
    }
}




