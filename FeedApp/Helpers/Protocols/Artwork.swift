//
//  Artwork.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import Foundation

/// Protocol that contains a `imageURL` and `thumbnailURL` as `String?`
/// Allows reusability across views that will only display a certain image.
protocol Artwork {
    var imageURL: String { get }
    var thumbnailURL: String { get }
}
