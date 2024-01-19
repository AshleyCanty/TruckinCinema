//
//  MovieDBEndpoint.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation




struct MovieAPIHost {
    static let baseUrl = "api.themoviedb.org/3/movie"
    static let imageBaseUrl = "image.tmdb.org/t/p/original/"
    static let trailerThumbnailBaseUrl = "i.ytimg.com/vi"
    static let youtubeBaseUrl = "www.youtube.com/v" /// https://developers.google.com/youtube/iframe_api_reference
}

enum MovieAPIEndpoint {
    case getPopularMovies
    case getMovie(id: String)
    case getAllTrailers(id: String)
    case getReleaseDates(id: String)
    
    case getPoster(path: String)
    case getTrailer(key: String)
    case getTrailerThumbnail(key: String)
    
    var url: URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = queryItems
        return component.url
    }
    
    private var scheme: String {
        switch self {
        case .getTrailer(_):
            return "http"
        default:
            return "https"
        }
    }
    
    private var host: String {
        switch self {
        case .getPopularMovies, .getMovie(_), .getAllTrailers(_), .getReleaseDates(_):
            return MovieAPIHost.baseUrl
        case .getPoster(_):
            return MovieAPIHost.imageBaseUrl
        case .getTrailer(_):
            return MovieAPIHost.youtubeBaseUrl
        case .getTrailerThumbnail(_):
            return MovieAPIHost.trailerThumbnailBaseUrl
        }
    }
    
    private var path: String {
        switch self {
        case .getPopularMovies:
            return "popular"
        case .getMovie(let id), .getAllTrailers(let id), .getReleaseDates(let id):
            return id
        case .getPoster(let path):
            return path
        case .getTrailer(let key), .getTrailerThumbnail(let key):
            return key
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .getPopularMovies:
            return [URLQueryItem(name: "language", value: "en"),
                    URLQueryItem(name: "page", value: "1")]
        case .getReleaseDates(_):
            return [URLQueryItem(name: "language", value: "en"),
                    URLQueryItem(name: "append_to_response", value: "release")]
        default:
            return []
        }
    }
}
