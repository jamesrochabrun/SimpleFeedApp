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
typealias DiscoverFeedSectionModel = GenericSectionIdentifierViewModel<DiscoverFeedSectionIdentifier, FeedItemViewModel>

final class DiscoverViewController: GenericFeedViewController<DiscoverFeedSectionModel, ItunesRemote> {
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVEpisodes(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView?.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
        
        collectionView?.supplementaryViewProvider { collectionView, model, kind, indexPath in
            guard let model = model else { return nil }
            switch model {
            case .popular:
                let header: DiscoveryFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 120.0).layout
                return header
            }
        }
    }
    
    override func updateUI() {
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            let items = models.chunked(into: max(models.count / 2, 1))
            self.collectionView?.content {
                DiscoverFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: items.last ?? [])
            }
        }.store(in: &cancellables)
    }
}
