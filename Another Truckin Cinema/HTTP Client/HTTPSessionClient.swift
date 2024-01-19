//
//  HTTPSessionClient.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/30/23.
//

import Foundation


class HTTPSessionClient: HTTPClient {
    func processFetch<T>(withUrl url: URL, forType type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        let result = try! JSONDecoder().decode(type, from: Data())
        return result
    }
    
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    
    func get(with url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        
    }
}
