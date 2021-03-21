//
//  Artwork.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import Foundation

public protocol Artwork {
    var imageURL: String? { get }
    var thumbnailURL: String? { get }
}
