//
//  HTTPClientSpy.swift
//  Another Truckin CinemaTests
//
//  Created by ashley canty on 12/30/23.
//

import Foundation
import XCTest
@testable import Another_Truckin_Cinema


class HTTPClientSpy: HTTPClient {
    var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    var requestedUrls: [URL] {
        return messages.map { $0.url }
    }
    
    func get(with url: URL, completion: @escaping (HTTPClientSpy.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int, file: StaticString = #filePath, lineNumber: UInt = #line) {
        guard requestedUrls.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }

        messages[index].completion(.failure(error))
    }
    
    func complete(with statusCode: Int, data: Data, at index: Int = 0, file: StaticString = #filePath, lineNumber: UInt = #line) {
        guard requestedUrls.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: lineNumber)
        }
        
        let response = HTTPURLResponse(
            url: requestedUrls[index],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
        
        messages[index].completion(.success((data, response)))
    }
}
