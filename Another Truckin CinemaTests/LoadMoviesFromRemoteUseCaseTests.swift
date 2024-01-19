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
    
    func test_load_requestsFromURLOnlyOnce() async throws {
        let (sut, client) = makeSUT()
        Task {
            try await sut.load(with: .popularMovies, completion: { _ in })
            XCTAssertEqual(client.requestedUrls.count, 1)
        }
    }

    func test_load_returnsConnectivityErrorWithFailedResponse() async throws {
        let client = APIClientSpy()
        let sut = RemoteMovieLoader(client: client)

        try await expect(sut: sut, toCompleteWith: .failure(RemoteMovieLoader.Error.connectivity)) {
            Task {
                await client.complete(with: RemoteMovieLoader.Error.invalidUrl, at: 0)
            }
        }
    }

    func test_load_returnsInvalidDataErrorWhenStatusIsNot200() async throws {
        let client = APIClientSpy()
        let sut = RemoteMovieLoader(client: client)

        let statusCodes = [199, 202, 300, 404, 400]
        statusCodes.enumerated().forEach { index, code in
            Task {
                try await expect(sut: sut, toCompleteWith: .failure(RemoteMovieLoader.Error.invalidData)) {
                    Task {
                        await client.complete(with: code, at: index)
                    }
                }
            }
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() async throws {
        let (sut, client) = makeSUT()
        try await expect(sut: sut, toCompleteWith: .failure(RemoteMovieLoader.Error.invalidData)) {
            Task {
                await client.complete(with: 200, data: client.loadData(filename: MockableResource.PartialPopularMovies), file: #file, lineNumber: #line)
            }
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() async throws {
        let (sut, client) = makeSUT()
        try await expect(sut: sut, toCompleteWith: .failure(RemoteMovieLoader.Error.invalidData)) {
            Task {
                await client.complete(with: 200, data: client.loadData(filename: MockableResource.PartialPopularMovies), file: #file, lineNumber: #line)
            }
        }
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() async throws {
        let (sut, client) = makeSUT()
        try await expect(sut: sut, toCompleteWith: .success(client.loadJSON(filename: MockableResource.EmptyPopularMovies, type: PopularMovies.self))) {
            Task {
                await client.complete(with: 200, data: client.loadData(filename: MockableResource.EmptyPopularMovies), file: #file, lineNumber: #line)
            }
        }
    }
    
    func test_load_deliversSuccessWithItemsOn200HTTPResponseWithJSONItems() async throws {
        let (sut, client) = makeSUT()
        try await expect(sut: sut, toCompleteWith: .success(client.loadJSON(filename: MockableResource.PopularMovies, type: PopularMovies.self))) {
            Task {
                await client.complete(with: 200, data: client.loadData(filename: MockableResource.PopularMovies), file: #file, lineNumber: #line)
            }
        }
    }
    
    func test_load_doesNotMakeRequestAfterDeallocation() async throws {
        let client = APIClientSpy()
        var sut: RemoteMovieLoader? = RemoteMovieLoader(client: client)
        
        var capturedResults = [RemoteMovieLoader.Result]()
        try await sut?.load(with: .popularMovies) { capturedResults.append($0) }
        
        sut = nil
        await client.complete(with: 200, data: Data())
        XCTAssertNil(sut)
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteMovieLoader, client: APIClientSpy) {
        let client = APIClientSpy()
        let sut = RemoteMovieLoader(client: client)
        
        return (sut, client)
    }
}

extension LoadMoviesFromRemoteUseCaseTests {
    func expect(sut: RemoteMovieLoader, toCompleteWith expectedResult: Result<PopularMovies, RemoteMovieLoader.Error>, when action: (() -> Void), file: StaticString = #filePath, line: UInt = #line) async throws {
        
        let expectation = XCTestExpectation(description: "Wait for load completion")
        
        try await sut.load(with: .popularMovies) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                let recItems = receivedItems as! PopularMovies
                let expItems = expectedItems
                XCTAssertEqual(recItems, expItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as! RemoteMovieLoader.Error, expectedError, file: file, line: line)
            default:
                XCTFail("Was expecting \(expectedResult) but received \(receivedResult)", file: file, line: line)
            }
            expectation.fulfill()
        }
        
        action()

        await fulfillment(of: [expectation])
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "INstance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
