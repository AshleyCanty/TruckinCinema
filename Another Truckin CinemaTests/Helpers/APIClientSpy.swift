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
    var messages = [(url: URL, completion: (APIClient.Result) -> Void)]()
    
    var requestedUrls: [URL] {
        return messages.map({ $0.url })
    }

    func fetch(withUrl url: URL, headers: [(value: String, headerField: String)]?, completion: @escaping ((APIClient.Result) -> Void)) async {
        messages.append((url, completion))
        print()
    }
    
    func complete(with error: Error, at index: Int, file: StaticString = #filePath, lineNumber: UInt = #line) {
        guard requestedUrls.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }

        messages[index].completion(.failure(error))
    }
    
    func complete(with statusCode: StatusCode, data: Data = Data(), at index: Int = 0, file: StaticString = #filePath, lineNumber: UInt = #line) {
        print()
        guard requestedUrls.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }
        let url = requestedUrls[index]
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
        
        messages[index].completion(.success((data, response)))
    }
}
