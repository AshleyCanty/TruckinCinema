//
//  Mockable.swift
//  Another Truckin CinemaTests
//
//  Created by ashley canty on 1/15/24.
//

import Foundation

enum MockableResource {
    static let PopularMovies = "PopularMoviesResponse"
    static let PartialPopularMovies = "PartialPopularMovies"
    static let EmptyPopularMovies = "EmptyPopularMovies"
}

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadData(filename: String) -> Data
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadData(filename: String) -> Data {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file")
        }
        
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            print("❌")
            fatalError("Failed to load data")
        }
    }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let data = try Data(contentsOf: path)
            let decodedObject = try decoder.decode(type.self, from: data)
            
            return decodedObject
        } catch {
            print("❌")
            fatalError("Failed to decode the JSON")
        }
    }
}
