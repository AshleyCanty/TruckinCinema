//
//  APIClientSpy.swift
//  Another Truckin CinemaTests
//
//  Created by ashley canty on 12/30/23.
//

import Foundation
import XCTest
@testable import Another_Truckin_Cinema





class APIClientSpy: APIClient {

    var session: URLSession = URLSession(configuration: .default)
    
    typealias StatusCode = Int
    var messages = [(request: APIRequestStub, completion: (APIClient.Result) -> Void)]()
    
    var receivedRequests: [APIRequestStub] {
        return messages.map({ $0.request })
    }
    
    func fetch<T>(with request: T, completion: @escaping ((APIClient.Result) -> Void)) async where T : APIRequest {
        guard let requestStub = request as? APIRequestStub else { return }
        messages.append((requestStub, completion))
    }
    
    func complete(with error: Error, at index: Int, file: StaticString = #filePath, lineNumber: UInt = #line) {
        guard receivedRequests.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }

        messages[index].completion(.failure(error))
    }
    
    func complete(with statusCode: StatusCode, data: Data = Data(), at index: Int = 0, file: StaticString = #filePath, lineNumber: UInt = #line) {
        guard receivedRequests.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }
        let url = try receivedRequests[index].url()
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
        
        messages[index].completion(.success((data, response)))
    }
}
