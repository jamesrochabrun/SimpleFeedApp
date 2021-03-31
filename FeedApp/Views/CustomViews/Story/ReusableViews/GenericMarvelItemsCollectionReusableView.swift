//
//  GenericMarvelItemsCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit
import Combine

class GenericMarvelItemsCollectionReusableView<Content: SectionIdentifierViewModel, ViewModel: Hashable>: UICollectionReusableView, ViewModelReusableViewConfiguration {
       
    // MARK:- Typealias
    typealias CollectionView = DiffableCollectionView<Content>

    // MARK:- Combine
    var marvelProvider = MarvelRemote()
    var cancellable: AnyCancellable?
    
    // MARK:- UI
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.overrideLayout = layout
        }
    }
    
    // MARK:- Public
    lazy var collectionView: CollectionView = {
        CollectionView(layout: UICollectionViewFlowLayout())
    }()
    
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
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    // MARK:- ViewModelReusableViewConfiguration
    func configureSupplementaryView(with viewModel: ViewModel) {
        setupWith(viewModel)
    }
    
    // MARK:- Public Configuration
    /// To be overriden. Super does not need to be called.
    func setupWith(_ viewModel: ViewModel) {
    }
}
