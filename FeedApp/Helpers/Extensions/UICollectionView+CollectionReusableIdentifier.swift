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
    
    /// Dequeue a cell
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
      //  register(T.self)
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
    
    /// Dequeue a supplementary view
    func dequeueSuplementaryView<T: UICollectionReusableView>(of kind: String, at indexPath: IndexPath) -> T {
        let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return supplementaryView
    }
}


extension UICollectionView {
    
    /// MARK:-  ViewModelCellConfiguration
    
    /// Cell Configuration for a cell in a NIB file
    /// - parameter viewModel: The view model that will be injected, defined in the protocol `ViewModelCellConfiguration`
    /// - parameter indexPath: The indexpath of the cell.
    func dequeueAndConfigureReusableNibCell<Cell: ViewModelCellConfiguration>(with viewModel: Cell.ViewModel, at indexPath: IndexPath) -> Cell {
        registerNib(Cell.self)
        return dequeue(with: viewModel, at: indexPath)
    }
    
    /// Cell Configuration
    /// - parameter viewModel: The view model that will be injected, defined in the protocol `ViewModelCellConfiguration`
    /// - parameter indexPath: The indexpath of the cell.
    func dequeueAndConfigureReusableCell<Cell: ViewModelCellConfiguration>(with viewModel: Cell.ViewModel, at indexPath: IndexPath) -> Cell {
        register(Cell.self)
        return dequeue(with: viewModel, at: indexPath)
    }
    
    /// Private method to deque and configure a cell
    /// - parameter viewModel: The view model that will be injected, defined in the protocol `ViewModelCellConfiguration`
    /// - parameter indexPath: The indexpath of the cell.
    private func dequeue<Cell: ViewModelCellConfiguration>(with viewModel: Cell.ViewModel, at indexPath: IndexPath) -> Cell {
        let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.configureCell(with: viewModel)
        return cell
    }
    
    /// ViewModelReusableViewConfiguration
    func dequeueAndConfigureSuplementaryView<SupplementaryView: ViewModelReusableViewConfiguration>(with viewModel: SupplementaryView.ViewModel, of kind: String, at indexPath: IndexPath) -> SupplementaryView {
        registerHeader(SupplementaryView.self, kind: kind)
        let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as! SupplementaryView
        supplementaryView.configureSupplementaryView(with: viewModel)
        return supplementaryView
    }
}
