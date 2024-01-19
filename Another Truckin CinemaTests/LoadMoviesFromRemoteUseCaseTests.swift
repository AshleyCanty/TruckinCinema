//
//  LoadMoviesFromRemoteUseCaseTests.swift
//  Another Truckin CinemaTests
//
//  Created by ashley canty on 12/30/23.
//

import Foundation
import XCTest
@testable import Another_Truckin_Cinema


class LoadMoviesFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_sutIsNotNil() {
        let (sut, _) = makeSUT()
        
        XCTAssertNotNil(sut)
    }
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_load_requestsFromURLOnlyOnce() {
        let (sut, client) = makeSUT()
        
        sut.load(completion: { _ in })
        XCTAssertEqual(client.requestedUrls.count, 1)
    }
    
    func test_load_doesNotMakeRequestAfterDeallocation() {
        let url = URL(string: "https://www.something.com")!
        let client = HTTPClientSpy()
        var sut: RemoteMovieLoader? = RemoteMovieLoader(url: url, client: client)
        
        var capturedResults = [RemoteMovieLoader.Result]()
        sut?.load { capturedResults.append($0) }
        sut = nil
        
        client.complete(with: 200, data: Data())
        XCTAssertNil(sut)
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    func test_load_returnsConnectivityErrorWithFailedResponse() {
        
    }
    
    func test_load_returnsInvalidDataErrorWhenStatusIsNot200() {
        let url = URL(string: "https://www.something.com")!
        let client = HTTPClientSpy()
        var sut = RemoteMovieLoader(url: url, client: client)
        
        let statusCodes = [199, 202, 300, 404, 400]
        statusCodes.enumerated().forEach { index, code in
            var capturedErrors = [RemoteMovieLoader.Error]()
                
            expect(sut: sut, toCompleteWith: .failure(RemoteMovieLoader.Error.invalidData)) {
                client.complete(with: code, at: index)
            }
        }
    }
    
    func test_load_decodeDataIntoJSON() {
        
    }
    
    // Helpers
    
    private func makeSUT(url: URL = URL(string: "https://www.something.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        
        return (sut, client)
    }
}

extension LoadMoviesFromRemoteUseCaseTests {
    func expect(sut: RemoteMovieLoader, toCompleteWith expectedResult: Result<[Movie], RemoteMovieLoader.Error>, when action: (() -> Void), file: StaticString = #filePath, line: UInt = #line) {
        
        let expectation = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as! RemoteMovieLoader.Error, expectedError, file: file, line: line)
            default:
                XCTFail("Was expecting \(expectedResult) but received \(receivedResult)", file: file, line: line)
            }
            expectation.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 1)
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "INstance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
