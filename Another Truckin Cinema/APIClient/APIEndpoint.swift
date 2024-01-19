//
//  APIEndpoint.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation

// refactor - "URLComponents in an enum" from
// https://medium.com/swlh/building-urls-in-swift-51f21240c537
// to handle stored paths and queries


protocol APIEndpoint {
    static var baseUrl: URL { get }
    
    static func endpoint<T: APIRequest>(for request: T) -> URL?
}

extension APIEndpoint {
    static func endpoint<T: APIRequest>(for request: T) -> URL? {
        let paths = request.paths
        let queryItems = request.queryItems
        
        guard !paths.isEmpty else { return nil }
        
        /// Append paths to baseURL
        var localBaseUrl = baseUrl
        paths.forEach { localBaseUrl = localBaseUrl.appendingPathComponent($0) }
        
        /// Add query items
        var urlComponents = URLComponents(string: localBaseUrl.absoluteString)
        urlComponents?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents?.url else { return nil }
        return url
    }
}

