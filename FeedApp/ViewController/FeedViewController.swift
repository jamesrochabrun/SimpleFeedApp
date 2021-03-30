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

final class FeedViewController: ViewController {
    
    // MARK:- Data injection
    private var feed: [[FeedItemViewModel]] = []

    // MARK:- Section ViewModel
    private typealias FeedSectionModel = GenericSectionIdentifierViewModel<FeedSectionIdentifier, FeedItemViewModel>
    
    // MARK:- TypeAlias
    private typealias CollectionView = DiffableCollectionView<FeedSectionModel>
    
    // MARK:- UI
    private lazy var collectionView: CollectionView = {
        let feed = CollectionView()
        feed.layout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: splitViewController?.displayMode ?? .allVisible)
        return feed
    }()
    
    // MARK:- Life Cycle
    convenience init(feed: [[FeedItemViewModel]]) {
        self.init()
        self.feed = feed
    }
    
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
        
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as FeedItemCell
        }
        
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            switch model {
            case .recent:
                /// Intentionally left for now,
                collectionView.registerHeader(DiscoveryFeedSupplementaryView.self, kind: kind)
                let header: DiscoveryFeedSupplementaryView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                header.viewModel = .popular
                return header
            default: return UICollectionReusableView()
            }
        }
    }
    
    private func updateUI() {
        
        let flatCellidentifiers = feed.reduce([], +) /// Making it flat to display just a list of items without any kind of section separation.
        collectionView.content {
            FeedSectionModel(sectionIdentifier: .recent, cellIdentifiers: flatCellidentifiers)
        }
    }
}

// MARK:- UserProfileFeedSelectionDelegate Protocol conformance
extension FeedViewController: UserProfileViewControllerDelegate {
    
    func postSelectedAt(_ indexPath: IndexPath) {
        /// As result of flatting the array we need to
        let normalizedIndexPath = IndexPath(row: indexPath.item, section: 0)
        let animated = traitCollection.isRegularWidthRegularHeight
        // TODO: fix bug on scrolling
        collectionView.scrollTo(normalizedIndexPath, animated: animated)
    }
}

extension FeedViewController: DisplayModeUpdatable {
    
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        /// Just to Satisfy Protocol
    }
    
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        collectionView.layout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: displayMode)
    }
}
