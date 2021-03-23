//
//  FeedViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import Combine


// MARK:- User profile Feed Diffable Section Identifier
enum FeedSectionIdentifier: String {
    case recent
}

final class FeedViewController<ViewModel: SectionIdentifierViewModel>: ViewController {
    
    // MARK:- Data injection
    var feed: [ViewModel] = []

    // MARK:- Section ViewModel
    private typealias FeedSectionModeling = GenericSectionIdentifierViewModel<FeedSectionIdentifier, ViewModel.CellIdentifier, FeedItemCell>
    
    // MARK:- TypeAlias
    private typealias CollectionView = DiffableCollectionView<FeedSectionModeling>
    
    // MARK:- UI
    private lazy var collectionView: CollectionView = {
        let feed = CollectionView()
        feed.layout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(header: false, displayMode: splitViewController?.displayMode ?? .allVisible)
        return feed
    }()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setUpUI()
        updateUI()
    }
    
    private func setupNavigationItems() {
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    private func setUpUI() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func updateUI() {
        
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .recent:
                collectionView.registerHeader(StoriesWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                return header
            default: return UICollectionReusableView()
            }
        }
                
        let flatCellidentifiers = feed.compactMap { $0.cellIdentifiers }.reduce([], +) /// Making it flat to display just a list of items without any kind of section separation.
        let feedSectionItems = FeedSectionModeling(sectionIdentifier: .recent, cellIdentifiers: flatCellidentifiers)
        collectionView.applyInitialSnapshotWith([feedSectionItems])
    }
}

// MARK:- UserProfileFeedSelectionDelegate Protocol conformance
extension FeedViewController: UserProfileViewControllerDelegate {
    
    func postSelectedAt(_ indexPath: IndexPath) {
        /// As result of flatting the array we need to 
        let normalizedIndexPath = IndexPath(row: indexPath.item, section: 0)
        collectionView.scrollTo(normalizedIndexPath)
    }
}

extension FeedViewController: DisplayModeUpdatable {
    
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        /// Just to Satisfy Protocol
    }
    
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        collectionView.layout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(header: false, displayMode: displayMode)
    }
}
