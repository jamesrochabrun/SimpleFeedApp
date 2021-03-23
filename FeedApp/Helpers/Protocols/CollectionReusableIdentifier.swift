//
//  CollectionReusableIdentifier.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

/// Protocol that allows use the class as a string, use it to define identifiers
protocol CollectionReusableIdentifier {}

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
