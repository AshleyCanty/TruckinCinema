//
//  MovieLoader.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


enum MovieDBRequestType {
    case popularMovies
    case singleMovie(withMovieId: String)
    case movieTrailers(withMovieId: String)
    case movieRatingAndReleaseDates(withMovieId: String)
}

enum MovieAccessoryType {
    case poster(withPath: String)
    case trailer(withKey: String)
    case trailerThumbnail(withKey: String)
}

protocol MovieLoader {
    typealias Result = Swift.Result<Decodable, Error>
    
    func load<T: APIRequest>(forRequest request: T, completion: @escaping (Result) -> Void)
}
