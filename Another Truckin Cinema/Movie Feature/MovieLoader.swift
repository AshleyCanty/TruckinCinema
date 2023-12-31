//
//  MovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


protocol MovieLoader {
    typealias Result = Swift.Result<[Movie], Error>
    
    func load(completion: @escaping (Result) -> Void)
}


