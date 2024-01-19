//
//  APIRequest.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 1/7/24.
//

import Foundation



protocol APIRequest {
    associatedtype Response: Decodable

    var paths: [String] { get }
    var queryItems: [String: String] { get }
    var headers: [String: String] { get }
    
    func url() -> URL?
}
