//
//  GenericFeedViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit
import Combine


/// Generic View Controller that displays any kind of feed from a Remote Observable Object.
/// It has a generic constraint of `SectionIdentifierViewModel`
/// It has a generic Constraint of `RemoteObservableObject`
/// Inherits from `ViewController`
class GenericFeedViewController<Content: SectionIdentifierViewModel, Remote: RemoteObservableObject>: ViewController {
    
    // MARK:- TypeAlias
    typealias CollectionView = DiffableCollectionView<Content>
    var collectionView: CollectionView 
    
    // MARK:- Data
    var cancellables: Set<AnyCancellable> = []
    let remote = Remote()
    
    // MARK:- LifeCycle
    init(layout: UICollectionViewLayout) {
        self.collectionView = CollectionView(layout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.collectionView = CollectionView(layout:  UICollectionViewLayout())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        fetchData()
        setUpUI()
        updateUI()
    }
    
    /// To be overriden. Super does not need to be called.
    func fetchData() {
        
    }
    
    /// To be overriden. Super does not need to be called.
    func setUpUI() {
        
    }

    /// To be overriden. Super does not need to be called.
    func updateUI() {
        
    }
}
