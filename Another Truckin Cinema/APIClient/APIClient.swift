//
//  HTTPClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation

protocol APIClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    var session: URLSession { get }
        
    func fetch<T: APIRequest>(with request: T, completion: @escaping ((Result) -> Void)) async
}

// refactor - do json parsing in fetch method and change result type to T.Response
extension APIClient {
    func fetch<T: APIRequest>(with request: T, completion: @escaping ((Result) -> Void)) async {
        
        guard let url = try? request.url() else {
            return completion(.failure(APIError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        request.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        guard let (data, response) = try? await session.data(for: urlRequest),
              let httpResponse = response as? HTTPURLResponse else {
            return completion(.failure(APIError.connectivity))
        }
        
        return completion(.success((data, httpResponse)))
    }
        
//        return completion(decodeData(usingType: T.Response.self, data: data, response: httpResponse))
    
//    func decodeData<T: Decodable>(usingType type: T.Type, data: Data, response: HTTPURLResponse) -> Result {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "MMM d, yyyy"
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//
//        guard response.statusCode == 200, let results = try? decoder.decode(type.self, from: data) else {
//            return .failure(APIError.invalidData)
//        }
//
//        return .success(results)
//    }
}
