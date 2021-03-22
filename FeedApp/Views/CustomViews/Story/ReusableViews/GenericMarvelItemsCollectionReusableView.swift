//
//  GenericMarvelItemsCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit
import Combine

class GenericMarvelItemsCollectionReusableView<Content: SectionIdentifierViewModel, ViewModel: Hashable>: UICollectionReusableView, ViewModelReusableViewInjection {
       
    // MARK:- Typealias
    typealias CollectionView = DiffableCollectionView<Content>

    // MARK:- Dependency
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupWith(viewModel)
        }
    }
    
    // MARK:- Combine
    var marvelProvider = MarvelRemote()
    var cancellable: AnyCancellable?
    
    // MARK:- UI
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView?.layout = layout
        }
    }
    
    // MARK:- Public
    var collectionView: CollectionView?
    
    // MARK:- LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        collectionView = CollectionView()
        guard let collectionView = collectionView else { return }
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    // MARK:- Configuration
    /// To be overriden. Super does not need to be called.
    func setupWith(_ viewModel: ViewModel) {
    }
}
