//
//  Feed.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation

/**
 Example payload.
 {
 "feed": {
 "title": "Best of 2018 Albums",
 "id": "https://rss.itunes.apple.com/api/v1/ca/apple-music/new-releases/all/10/explicit.json",
 "author": {
 "name": "iTunes Store",
 "uri": "http://wwww.apple.com/ca/itunes/"
 },
 "links": [
 {
 "self": "https://rss.itunes.apple.com/api/v1/ca/apple-music/new-releases/all/10/explicit.json"
 },
 {
 "alternate": "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewRoom?fcId=998773106&app=music"
 }
 ],
 "copyright": "Copyright © 2018 Apple Inc. All rights reserved.",
 "country": "ca",
 "icon": "http://itunes.apple.com/favicon.ico",
 "updated": "2019-01-11T01:21:37.000-08:00",
 "results": [
 {
 "artistName": "Drake",
 "id": "1418213110",
 "releaseDate": "2018-06-29",
 "name": "Scorpion",
 "kind": "album",
 "copyright": "℗ 2018 Young Money/Cash Money Records",
 "artistId": "271256",
 "contentAdvisoryRating": "Explicit",
 "artistUrl": "https://music.apple.com/ca/artist/drake/271256?app=music",
 "artworkUrl100": "https://is4-ssl.mzstatic.com/image/thumb/Music128/v4/d5/7d/47/d57d4729-3acf-e6d6-1c75-2074e9cb27ec/00602567892410.rgb.jpg/200x200bb.png",
 "genres": [
 {
 "genreId": "18",
 "name": "Hip-Hop/Rap",
 "url": "https://itunes.apple.com/ca/genre/id18"
 },
 {
 "genreId": "34",
 "name": "Music",
 "url": "https://itunes.apple.com/ca/genre/id34"
 },
 {
 "genreId": "1076",
 "name": "Rap",
 "url": "https://itunes.apple.com/ca/genre/id1076"
 },
 {
 "genreId": "15",
 "name": "R&B/Soul",
 "url": "https://itunes.apple.com/ca/genre/id15"
 },
 {
 "genreId": "1136",
 "name": "Contemporary R&B",
 "url": "https://itunes.apple.com/ca/genre/id1136"
 }
 ],
 "url": "https://music.apple.com/ca/album/scorpion/1418213110?app=music"
 },
 {
 "artistName": "Post Malone",
 "id": "1373516902",
 "releaseDate": "2018-04-27",
 "name": "beerbongs & bentleys",
 "kind": "album",
 "copyright": "℗ 2018 Republic Records, a division of UMG Recordings, Inc.",
 "artistId": "966309175",
 "contentAdvisoryRating": "Explicit",
 "artistUrl": "https://music.apple.com/ca/artist/post-malone/966309175?app=music",
 "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/9f/54/d0/9f54d048-2e01-63ff-2efc-4f1c5d8fe1be/00602567647461.rgb.jpg/200x200bb.png",
 "genres": [
 {
 "genreId": "18",
 "name": "Hip-Hop/Rap",
 "url": "https://itunes.apple.com/ca/genre/id18"
 },
 {
 "genreId": "34",
 "name": "Music",
 "url": "https://itunes.apple.com/ca/genre/id34"
 },
 {
 "genreId": "1076",
 "name": "Rap",
 "url": "https://itunes.apple.com/ca/genre/id1076"
 },
 {
 "genreId": "1068",
 "name": "Alternative Rap",
 "url": "https://itunes.apple.com/ca/genre/id1068"
 }
 ],
 "url": "https://music.apple.com/ca/album/beerbongs-bentleys/1373516902?app=music"
 }
 .... more items.....
 
 Leaving this paylod so dev can understand the below structures.
 - Every feed from the https://rss.itunes.apple.com/en-us/?country=ca will have the same root structure.
 */

/// Idea from personal blog https://blog.usejournal.com/advanced-generics-and-protocols-in-swift-c30020fd5ded

struct Author: Decodable {
    let name: String
    let uri: String
}

protocol ItunesResource: Decodable {
    associatedtype Model
    var title: String? { get }
    var id: String? { get }
    var author: Author? { get }
    var copyright: String? { get }
    var country: String? { get }
    var icon: String? { get }
    var updated: String? { get }
    var results: [Model]? { get }
}

struct ItunesResources<Model: Decodable>: ItunesResource {
    
    public let title: String?
    public let id: String?
    public let author: Author?
    public let copyright: String?
    public let country: String?
    public let icon: String?
    public let updated: String?
    public let results: [Model]?
}

protocol FeedProtocol: Decodable {
    associatedtype FeedResource: ItunesResource
    var feed: FeedResource? { get }
}

struct Feed<FeedResource: ItunesResource>: FeedProtocol {
    let feed: FeedResource?
}
