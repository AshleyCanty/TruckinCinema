//
//  MovieDBEndpoint.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation




struct MovieAPIBaseUrl {
    static let movieDBUrl = "https://api.themoviedb.org/3/movie"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/original/"
    static let trailerThumbnailBaseUrl = "https://i.ytimg.com/vi"
    static let youtubeBaseUrl = "http://www.youtube.com/v" /// https://developers.google.com/youtube/iframe_api_reference
}

enum MovieAPI {
    enum GET {
        case popularMovies
        case movie(withId: String)
        case allTrailers(withId: String)
        case releaseDates(withId: String)
        
        case poster(withPath: String)
        case trailer(withKey: String)
        case trailerThumbnail(withKey: String)
        
        var url: URL? {
            var localUrl: URL? = URL(string: baseUrl)
            paths.forEach { localUrl?.append(path: $0) }
            
            var component = URLComponents(string: localUrl?.absoluteString ?? baseUrl)
            component?.queryItems = queryItems
            return component?.url
        }
        
        private var scheme: String {
            switch self {
            case .trailer(_):
                return "http"
            default:
                return "https"
            }
        }
        
        private var baseUrl: String {
            switch self {
            case .popularMovies, .movie(_), .allTrailers(_), .releaseDates(_):
                return MovieAPIBaseUrl.movieDBUrl
            case .poster(_):
                return MovieAPIBaseUrl.imageBaseUrl
            case .trailer(_):
                return MovieAPIBaseUrl.youtubeBaseUrl
            case .trailerThumbnail(_):
                return MovieAPIBaseUrl.trailerThumbnailBaseUrl
            }
        }
        
        private var paths: [String] {
            switch self {
            case .popularMovies:
                return ["popular"]
            case .movie(let id), .allTrailers(let id), .releaseDates(let id):
                return [id]
            case .poster(let path):
                return [path]
            case .trailer(let key), .trailerThumbnail(let key):
                return [key]
            }
        }
        
        private var queryItems: [URLQueryItem] {
            switch self {
            case .popularMovies:
                return [URLQueryItem(name: "language", value: "en"),
                        URLQueryItem(name: "page", value: "1")]
            case .releaseDates(_):
                return [URLQueryItem(name: "language", value: "en"),
                        URLQueryItem(name: "append_to_response", value: "release")]
            default:
                return []
            }
        }
    }
}
