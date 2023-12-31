//
//  ImageDownloader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 7/24/23.
//

import Foundation
import UIKit

/// Actor Image caching
final actor URLCache {
    
    static let shared = URLCache()
    
    private var cache = [URL: Data]()
    
    private init() {}
    
    private func cacheImageData(using url: URL, data: Data) {
        cache[url] = data
    }
    
    public func downloadImageData(for url: URL) async throws -> Data {
        if let cached = cache[url] {
            return cached
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        cacheImageData(using: url, data: data)
        return data
    }
}
