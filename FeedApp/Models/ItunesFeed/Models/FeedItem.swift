//
//  FeedItem.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine

struct FeedItem: Decodable {
    
    public let artistName: String?
    public let id: String
    public let releaseDate: String?
    public let name: String
    public let kind: String
    public var copyright: String?
    public let artistId: String?
    public let artistUrl: String?
    public let artworkUrl100: String
    public let genres: [Genre]
    public let url: String
}

struct Genre: Decodable {
    let genreId: String
    let name: String
    let url: String
}
