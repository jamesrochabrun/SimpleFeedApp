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

public final class GenreViewModel: ObservableObject {
    
    @Published var genreId: String
    @Published var name: String
    @Published var url: String
    
    init(model: Genre) {
        genreId = model.genreId
        name = model.name
        url = model.url
    }
}

public final class FeedItemViewModel: IdentifiableHashable, ObservableObject {
    
    @Published public var artistName: String?
    @Published public var id: String
    @Published public var releaseDate: String?
    @Published public var name: String
    @Published public var kind: String
    @Published public var copyright: String?
    @Published public var artistId: String?
    @Published public var artistUrl: String?
    @Published public var artworkUrl100: String
    @Published public var genres: [GenreViewModel]
    @Published public var url: URL
    @Published public var artworkURL: URL
    
    init(model: FeedItem) {
        artistName = model.artistName
        id = model.id
        releaseDate = model.releaseDate
        name = model.name
        kind = model.kind
        copyright = model.copyright
        artistId = model.artistId
        artistUrl = model.artistUrl
        artworkUrl100 = model.artworkUrl100
        genres = model.genres.map { GenreViewModel(model: $0) }
        url = URL(string: model.url)!
        artworkURL = URL(string: model.artworkUrl100)!
    }
}

/// Protocol composition with an extension to provide `Hashable` conformance to an object.
public protocol IdentifiableHashable: Hashable & Identifiable {}
public extension IdentifiableHashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FeedItemViewModel: Artwork {
    
    public var imageURL: String? { artworkUrl100 }
    public var thumbnailURL: String? { artworkUrl100 }
}
