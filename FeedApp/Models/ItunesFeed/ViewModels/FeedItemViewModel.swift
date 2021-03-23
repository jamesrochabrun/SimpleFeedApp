//
//  FeedItemViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import Foundation

final class FeedItemViewModel: IdentifiableHashable {
    
    let artistName: String?
    let id: String
    let releaseDate: String?
    let name: String
    let kind: String
    let copyright: String?
    let artistId: String?
    let artistURL: String?
    let artworkURL: String
    let artworkURLThumbnail: String
    let genres: [GenreViewModel]
    let url: URL
    
    init(model: FeedItem) {
        artistName = model.artistName
        id = model.id
        releaseDate = model.releaseDate
        name = model.name
        kind = model.kind
        copyright = model.copyright
        artistId = model.artistId
        artistURL = model.artistUrl
        artworkURL = model.artWorkURL
        genres = model.genres.map { GenreViewModel(model: $0) }
        url = URL(string: model.url)!
        artworkURLThumbnail = model.artWorkURL.replacingOccurrences(of: "200x200bb.png", with: "100x100bb.png")
    }
}

final class GenreViewModel {
    
    let genreId: String
    let name: String
    let url: String
    
    init(model: Genre) {
        genreId = model.genreId
        name = model.name
        url = model.url
    }
}

extension FeedItemViewModel: Artwork {
    
    public var imageURL: String { artworkURL }
    public var thumbnailURL: String { artworkURLThumbnail }
}
