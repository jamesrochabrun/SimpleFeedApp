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
    
    // MARK:- Data
    var cancellables: Set<AnyCancellable> = []
    let remote = Remote()
    
    // MARK:- LifeCycle
    convenience init(layout: UICollectionViewLayout) {
        self.init()
        collectionView = CollectionView()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.layout = layout
    }
    
    // MARK:- TypeAlias
    typealias CollectionView = DiffableCollectionView<Content>
    var collectionView: CollectionView! // document
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
