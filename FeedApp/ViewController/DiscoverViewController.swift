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
enum DiscoverFeedSectionIdentifier {
    case popular
    case adds
}

final class DiscoverViewController: GenericFeedViewController<DiscoverViewController.SectionModel, ItunesRemote> {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Discovery feed.
    typealias SectionModel = GenericSectionIdentifierViewModel<DiscoverFeedSectionIdentifier, FeedItemViewModel>

    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVEpisodes(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
        
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                let header: DiscoveryFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 120.0).layout
                return header
            case .adds:
                let header: DiscoveryFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 120.0).layout
                return header
            }
        }
        
        collectionView.selectedContentAtIndexPath = { [weak self] viewModel, _ in
            guard let self = self else { return }
            self.collectionView.deleteItem(viewModel)
        }
    }
    
    override func updateUI() {
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            let items = models.chunked(into: max(models.count / 2, 1))
            self.collectionView.content {
                SectionModel(sectionIdentifier: .popular, cellIdentifiers: items.last ?? [])
            }
        }.store(in: &cancellables)
    }
}
