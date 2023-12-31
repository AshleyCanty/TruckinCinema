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
    
    // Helpers
    
    private func makeSUT() -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let url = URL(string: "https://www.something.com")!
        let client = HTTPClientSpy()
        
        let sut = RemoteMovieLoader(url: url, client: client)
        return (sut, client)
    }
}

