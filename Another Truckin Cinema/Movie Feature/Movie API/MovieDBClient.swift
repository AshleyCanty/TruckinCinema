//
//  MovieDBClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation

final class MovieDBClient: APIClient {
    typealias MovieDBClientHeader = [(headerField: String, value: String)]
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Returns a tuple containing the API Key and Bearer Token
    static func headers() -> MovieDBClientHeader {
        guard let filePath = Bundle.main.path(forResource: "API-Info", ofType: "plist") else {
            fatalError("Failed to find 'API-Info.plist'")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let dict = plist?.object(forKey: APIInfoPlistKey.tmdb) as? NSDictionary, let apiKey = dict.object(forKey: APIInfoPlistKey.apiKey) as? String, let bearerToken = dict.object(forKey: APIInfoPlistKey.bearerToken) else {
            fatalError("Register for a TMDB developer account and get an API key at https://developers.themoviedb.org/3/getting-started/introduction.")
        }
        
        return [(headerField: "apikey", value: apiKey),
                (headerField: "authorization", value: "Bearer \(bearerToken)")]
    }
}
