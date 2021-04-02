//
//  GenericFeedCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit
import Combine

class GenericFeedCollectionReusableView<Content: SectionIdentifierViewModel,
                                        Remote: RemoteObservableObject,
                                        ViewModel: Hashable>: UICollectionReusableView, ViewModelReusableViewConfiguration {
    // MARK:- Typealias
    typealias CollectionView = DiffableCollectionView<Content>

    // MARK:- Combine
    var marvelProvider = Remote()
    var cancellables: Set<AnyCancellable> = []

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
        collectionView.anchor(top: topAnchor, trailing: trailingAnchor)
        let collectionViewLeadingAnchor = collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        collectionViewLeadingAnchor.isActive = true
        collectionViewLeadingAnchor.priority = UILayoutPriority(999)
        let collectionViewBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        collectionViewBottomAnchor.isActive = true
        collectionViewBottomAnchor.priority = UILayoutPriority(999)
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
