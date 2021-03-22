//
//  CollectionReusableIdentifier.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

protocol CollectionReusableIdentifier {}

/// Disclaimer: From Apple UI engineer - its allow to force cast the cell in this method, if it fails its mostly another issue in the implementation.

extension CollectionReusableIdentifier where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// MARK:- UICollectionView
extension CollectionReusableIdentifier where Self: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UICollectionReusableView: CollectionReusableIdentifier {}
