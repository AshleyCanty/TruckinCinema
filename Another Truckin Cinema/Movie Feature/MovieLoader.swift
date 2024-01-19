//
//  MovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


enum MovieRequestType {
    case popularMovies
    case singleMovie(usingMovieId: String)
    case movieTrailers(usingMovieId: String)
    case movieRatingAndReleaseDates(usingMovieId: String)
}

protocol MovieLoader {
    typealias Result = Swift.Result<Codable, Error>
    
//    associatedtype
    // use asspicatedType to require enum from protocol
    // https://stackoverflow.com/questions/37353484/how-to-require-an-enum-be-defined-in-swift-protocol
    
    func load(forRequestType movieRequestType: MovieRequestType, completion: @escaping (Result) -> Void)
    
    
}
// trying to pass url type to loader somehow
// urlType goes to mapper AFTER client returns HTTP request results
// Mapper will take urlType and (data, response).
// Mapper or Loader will use urlType to determine the Decodable type to use
