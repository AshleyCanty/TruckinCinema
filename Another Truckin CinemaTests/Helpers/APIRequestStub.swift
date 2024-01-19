//
//  APIRequestStub.swift
//  Another Truckin CinemaTests
//
//  Created by ashley canty on 1/8/24.
//

import Foundation
import XCTest
@testable import Another_Truckin_Cinema


struct APIRequestStub: APIRequest {
    typealias Response = PopularMovies
    
    var paths: [String]
    
    var queryItems: [String : String]
    
    var headers: [String : String]
    
    init(paths: [String] = [], queryItems: [String : String] = [:], headers: [String : String] = [:]) {
        self.paths = paths
        self.queryItems = queryItems
        self.headers = headers
    }
    
    func url() throws -> URL {
        return URL(string: "")!
    }
}
