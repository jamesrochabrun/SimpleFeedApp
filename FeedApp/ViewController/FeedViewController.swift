//
//  FeedViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import Combine


enum UserFeedSectionIdentifier: String {
    case recent
}

final class FeedViewController<ViewModel: SectionIdentifierViewModel>: ViewController {
    
    // MARK:- Data
    var feed: [ViewModel] = []

    // MARK:- Section ViewModel
    private typealias FeedSectionModeling = GenericSectionIdentifierViewModel<UserFeedSectionIdentifier, ViewModel.CellIdentifier, FeedItemCell>
    
    // MARK:- TypeAlias
    private typealias CollectionView = DiffableCollectionView<FeedSectionModeling>
    
    // MARK:- UI
    private lazy var collectionView: CollectionView = {
        let feed = CollectionView()
        feed.layout = UICollectionViewCompositionalLayout.feedLayout()
        return feed
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func updateUI() {
        let flatCellidentifiers = feed.compactMap { $0.cellIdentifiers }.reduce([], +)
        let feedSectionItems = FeedSectionModeling(sectionIdentifier: .recent, cellIdentifiers: flatCellidentifiers)
        collectionView.applyInitialSnapshotWith([feedSectionItems])
    }
}

// MARK:- UserProfileFeedSelectionDelegate Protocol conformance
extension FeedViewController: UserProfileViewControllerDelegate {
    
    func postSelectedAt(_ indexPath: IndexPath) {
        print("indexpath \(indexPath)")
        let normalizedIndexPath = IndexPath(row: indexPath.item, section: 0)
        collectionView.scrollTo(normalizedIndexPath)
    }
}
