//
//  MovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


protocol MovieLoader {
    typealias Result = Swift.Result<Decodable, Error>
    
    func load(with endpoint: MovieAPI.GET, completion: @escaping (Result) -> Void) async throws
}
