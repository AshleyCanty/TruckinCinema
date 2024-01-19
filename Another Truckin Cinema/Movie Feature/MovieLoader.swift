//
//  MovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


protocol MovieLoader {
    typealias Result = Swift.Result<Codable, Error>
    
    func load<T: Codable>(forType type: T.Type, completion: @escaping (Result) -> Void)
    
    
}


