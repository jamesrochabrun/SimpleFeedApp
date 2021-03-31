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
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    // MARK:- Section ViewModel
    private typealias FeedSectionModel = GenericSectionIdentifierViewModel<FeedSectionIdentifier, FeedItemViewModel>
    
    // MARK:- TypeAlias
    private typealias CollectionView = DiffableCollectionView<FeedSectionModel>
    
    // MARK:- UI
    private lazy var collectionView: CollectionView = {
        let feed = CollectionView(layout: UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: splitViewController?.displayMode ?? .allVisible))
        return feed
    }()
    
    private var currentDisplayMode: UISplitViewController.DisplayMode = .allVisible
    
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
//
//            print("zizou whats up \(self.currentDisplayMode.text)")
//            if self.currentDisplayMode == .allVisible {
//                let cell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as FeedItemCell
//                cell.addBorder(.green, width: 5.0)
//                return cell
//            }
//            let cell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
//            cell.addBorder(#colorLiteral(red: 1, green: 0.02601638692, blue: 0.9704313794, alpha: 1), width: 5.0)
//            return cell
//
            
            let cell: FeedItemCell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as FeedItemCell
            cell.addBorder(.orange, width: 2.0)
            cell.displayMode = self.currentDisplayMode
            return cell
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
        
        let flatCellidentifiers = feed.reduce([], +) /// Making it flat to display just a list of items without any kind of section separation.
        collectionView.content {
            FeedSectionModel(sectionIdentifier: .recent, cellIdentifiers: flatCellidentifiers)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let animated = traitCollection.isRegularWidthRegularHeight
        collectionView.scrollTo(selectedIndexPath, animated: animated)
    }
}

// MARK:- UserProfileFeedSelectionDelegate Protocol conformance
extension FeedViewController: UserProfileViewControllerDelegate {
    
    func postSelectedAt(_ indexPath: IndexPath) {
        /// As result of flatting the array we need to
        selectedIndexPath = IndexPath(row: indexPath.item, section: 0)
    }
}

extension FeedViewController: DisplayModeUpdatable {
    
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
      //  collectionView.reloadData()

    }
    
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode) {
        currentDisplayMode = displayMode
        collectionView.overrideLayout = UICollectionViewCompositionalLayout.adaptiveFeedLayout(displayMode: displayMode)
    }
}

extension UISplitViewController.DisplayMode {
    
    var text: String {
        switch self {
        case .allVisible: return "allVisible"
        case .automatic: return "auto"
        case .oneBesideSecondary: return "oneBesideSecondary"
        case .oneOverSecondary: return "oneOverSecondary"
        case .secondaryOnly: return "secondaryOnly"
        case .twoBesideSecondary: return "twoBesideSecondary"
        case .twoDisplaceSecondary: return "twoDisplaceSecondary"
        case .twoOverSecondary: return "twoOverSecondary"
        case .primaryHidden: return "primaryHidden"
        }
    }
}
