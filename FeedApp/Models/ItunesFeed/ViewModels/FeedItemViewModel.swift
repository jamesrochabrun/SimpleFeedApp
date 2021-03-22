//
//  FeedItemViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import Foundation
import Combine

final class FeedItemViewModel: IdentifiableHashable, ObservableObject {
    
    @Published var artistName: String?
    @Published var id: String
    @Published var releaseDate: String?
    @Published var name: String
    @Published var kind: String
    @Published var copyright: String?
    @Published var artistId: String?
    @Published var artistUrl: String?
    @Published var artworkUrl100: String
    @Published var artworkUrlThumbnail: String
    @Published var genres: [GenreViewModel]
    @Published var url: URL
    
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
        artworkUrlThumbnail = model.artworkUrl100.replacingOccurrences(of: "200x200bb.png", with: "100x100bb.png")
    }
}

final class GenreViewModel: ObservableObject {
    
    @Published var genreId: String
    @Published var name: String
    @Published var url: String
    
    init(model: Genre) {
        genreId = model.genreId
        name = model.name
        url = model.url
    }
}

extension FeedItemViewModel: Artwork {
    
    public var imageURL: String { artworkUrl100 }
    public var thumbnailURL: String { artworkUrlThumbnail }
}
