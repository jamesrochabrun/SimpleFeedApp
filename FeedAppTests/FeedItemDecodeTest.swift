//
//  FeedItemDecodeTest.swift
//  FeedAppTests
//
//  Created by James Rochabrun on 5/7/21.
//

import Foundation
import XCTest
@testable import FeedApp

class FeedItemDecodeTest: XCTestCase {

    
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
    
    func testFeedItemDecode() {
        let feedItem = """
            {
            "artistName": "Various Artists",
            "id": "1513025488",
            "releaseDate": "2020-06-05",
            "name": "NOW That's What I Call Country Classics 90s",
            "kind": "album",
            "copyright": "This Compilation ℗ 2020 UMG Recordings, Inc. and Sony Music Entertainment",
            "artistId": "36270",
            "artworkUrl100": "https://is4-ssl.mzstatic.com/image/thumb/Music123/v4/01/3e/e3/013ee31c-9bd5-a443-7354-f7fb91a5724b/20UMGIM20236.rgb.jpg/200x200bb.png",
            "genres": [
            {
            "genreId": "6",
            "name": "Country",
            "url": "https://itunes.apple.com/us/genre/id6"
            },
            {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
            }
            ],
            "url": "https://music.apple.com/us/album/now-thats-what-i-call-country-classics-90s/1513025488?app=itunes"
            }
            """.data(using: .utf8)!
//
//        let test = try JSONDecoder().decode(FeedItem.self, from: feedItem)
//        XCTAssertNil(test)
    }
}
