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
    private var flatCellidentifiers: [FeedItemViewModel] = []
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            loadViewIfNeeded()
            let animated = traitCollection.isRegularWidthRegularHeight
            collectionView.scrollTo(selectedIndexPath, animated: animated)
        }
    }

    // MARK:- Section ViewModel
    private typealias FeedSectionModel = GenericSectionIdentifierViewModel<FeedSectionIdentifier, FeedItemViewModel>
    
    // MARK:- TypeAlias
    private typealias CollectionView = DiffableCollectionView<FeedSectionModel>
    
    // MARK:- UI
    private lazy var collectionView: CollectionView = {
        .init(layout: UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: splitViewController?.displayMode ?? .allVisible))
    }()
        
    // MARK:- Life Cycle
    convenience init(feed: [FeedItemViewModel]) {
        self.init()
        self.flatCellidentifiers = feed
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
            collectionView.dequeueAndConfigureReusableNibCell(with: model, at: indexPath) as FeedItemCell
        }
        
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            switch model {
            case .recent:
                /// Intentionally left for now,
                collectionView.registerHeader(DiscoveryFeedSupplementaryView.self, kind: kind)
                let header: DiscoveryFeedSupplementaryView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                header.configureSupplementaryView(with: .popular)
                return header
            default: return UICollectionReusableView()
            }
        }
    }
    
    private func updateUI() {
        collectionView.content {
            FeedSectionModel(sectionIdentifier: .recent, cellIdentifiers: flatCellidentifiers)
        }
    }
}

// MARK:- UserProfileFeedSelectionDelegate Protocol conformance
extension FeedViewController: UserProfileViewControllerDelegate {
    
    func postSelectedAt(_ indexPath: IndexPath) {
        /// As result of flatting the array we need to convert the indexPath section to 0.
        selectedIndexPath = .init(row: indexPath.item, section: 0)
    }
    
    func updateFeed(with feed: [FeedItemViewModel]) {
        // no need to update UI if no changes, consider using a set later, but this will be removed when using a better way to sync content between controllers
        guard flatCellidentifiers != feed else { return }
        flatCellidentifiers = feed
        updateUI()
    }
}

extension FeedViewController: DisplayModeUpdatable {
    
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        // Satisfy protocol
    }
    
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        collectionView.overrideLayout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: displayMode)
    }
}
