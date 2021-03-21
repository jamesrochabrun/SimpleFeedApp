//
//  DiscoverViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/16/21.
//

import Foundation
import Combine
import MarvelClient
import UIKit

enum DiscoverFeedSectionIdentifier: String {
    case popular = "Popular"
}

// MARK:- Section ViewModel
// document
private typealias DiscoverFeedSectionModeling = GenericSectionIdentifierViewModel<DiscoverFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>

final class DiscoverViewController: ViewController {
    
    // MARK:- Data
    private var cancellables: Set<AnyCancellable> = []
    private let itunesRemote = ItunesRemote()

    // MARK:- TypeAlias
    private typealias SearchFeedCollectionView = DiffableCollectionView<DiscoverFeedSectionModeling>
    
    // MARK:- UI
    private lazy var discoveryCollectionView: SearchFeedCollectionView = {
        let feed = SearchFeedCollectionView()
        feed.layout = GridLayoutKind.discover.layout
        return feed
    }()
    
    // MARK:- LifeCycle
    deinit {
        print("DEINIT \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        performOperations()
        updateUI()
    }
    
    private func setupViews() {
        view.addSubview(discoveryCollectionView)
        discoveryCollectionView.fillSuperview()
        
        discoveryCollectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                collectionView.registerHeader(StoriesWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 120.0).layout
                return header
            default: return StoriesWithAvatarCollectionReusableView() // Wont get executed
            }
        }
    }
    
    private func performOperations() {
        itunesRemote.fetch(.apps(feedType: .topFree(genre: .all), limit: 100))
    }
    
    private func updateUI() {
        itunesRemote.$sectionFeedViewModels.sink { [weak self] in
            let discoveryFeedSectionItems = [DiscoverFeedSectionModeling(sectionIdentifier: .popular, cellIdentifiers: $0)]
            self?.discoveryCollectionView.applyInitialSnapshotWith(discoveryFeedSectionItems)
        }.store(in: &cancellables)
    }
}
