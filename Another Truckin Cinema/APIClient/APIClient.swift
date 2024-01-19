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
    
    func fetch(withUrl url: URL, headers: [(value: String, headerField: String)]?, completion: @escaping ((Result) -> Void)) async
}

// refactor - do json parsing in fetch method and change result type to T.Response
extension APIClient {
    func fetch(withUrl url: URL, headers: [(value: String, headerField: String)]?, completion: @escaping ((Result) -> Void)) async {

        var urlRequest = URLRequest(url: url)
        if let headers = headers {
            headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.headerField) }
        }
        
        guard let (data, response) = try? await session.data(for: urlRequest), let httpResponse = response as? HTTPURLResponse else {
            print()
            return completion(.failure(APIError.connectivity))
        }
        print()
        return completion(.success((data, httpResponse)))
    }
}
