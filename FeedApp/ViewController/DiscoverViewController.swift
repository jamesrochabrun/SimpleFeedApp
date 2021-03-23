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


// MARK:- Discover Feed Diffable Section Identifier
enum DiscoverFeedSectionIdentifier: String {
    case popular = "Popular"
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the Discovery feed.
typealias DiscoverFeedSectionModel = GenericSectionIdentifierViewModel<DiscoverFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>

final class DiscoverViewController: GenericFeedViewController<DiscoverFeedSectionModel, ItunesRemote> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVEpisodes(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                collectionView.registerHeader(StoriesWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 120.0).layout
                return header
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return StoriesWithAvatarCollectionReusableView()
            }
        }
    }
    
    override func updateUI() {
        remote.$sectionFeedViewModels.sink { [weak self] in
            let discoveryFeedSectionItems = [DiscoverFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: $0)]
            self?.collectionView.applyInitialSnapshotWith(discoveryFeedSectionItems)
        }.store(in: &cancellables)
    }
}
