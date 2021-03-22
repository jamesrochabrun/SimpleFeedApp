//
//  UICollectionView+CollectionReusableIdentifier.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

extension UICollectionView {
    
    /// Register Programatic Cell
    func register<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Xib cell
    func registerNib<T: UICollectionViewCell>(_ :T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return cell
    }
    
    /// Register Programatic Header
    func registerHeader<T: UICollectionReusableView>(_ :T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Xib Header
    func registerNibHeader<T: UICollectionReusableView>(_ : T.Type, kind: String, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueSuplementaryView<T: UICollectionReusableView>(of kind: String, at indexPath: IndexPath) -> T {
        let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return supplementaryView
    }
}
