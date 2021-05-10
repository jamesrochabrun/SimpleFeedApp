//
//  FeedItem.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation

struct FeedItem: Codable {
    
    let artistName: String?
    let id: String
    let releaseDate: String?
    let name: String
    let kind: String
    let copyright: String?
    let artistId: String?
    let artistUrl: String?
    let artworkUrl100: String
  //  let genres: [Genre]
    let url: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case artistName, id, releaseDate, name, kind, copyright, artistId, artistUrl, genres, url
//        case artWorkURL = "artworkUrl100"
//    }
}

struct Genre: Codable {
    let genreId: String
    let name: String
    let url: String
}
