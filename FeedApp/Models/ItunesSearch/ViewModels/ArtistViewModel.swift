//
//  ArtistViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/7/21.
//

import Foundation

struct ArtistViewModel: IdentifiableHashable {
    
    let name: String
    let id: String
    
    init(artist: Artist) {
        name = artist.name ?? "No name provided"
        id = artist.id == nil ? UUID().uuidString : "\(String(describing: artist.id))"
    }
}
