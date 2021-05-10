//
//  FeedAppTests.swift
//  FeedAppTests
//
//  Created by James Rochabrun on 3/14/21.
//

import XCTest
@testable import FeedApp

class FeedAppTests: XCTestCase {

    let mockAPI = MockAPIClient()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDecodable() {
        
        // if we want to check the error:
        ///  mockAPI.shouldShowError = true
        
        
        let expectation = self.expectation(description: "Decode correctly")
        mockAPI.fetch(with: URLRequest(url: URL(string: "dummyreuqyes")!)) { $0 as? FeedItem
        } completion: { res in
            /// when done/// here we can check something like the json conversion and so on
            switch res {
            case let .success(model):
                expectation.fulfill()
                XCTAssertNotNil(model)
            case let .failure(err):
            XCTFail("\(err)")
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
}
