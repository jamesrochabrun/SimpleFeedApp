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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVEpisodes(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView?.cellProvider { collectionView, indexPath, model in
            let cell: ArtworkCell = collectionView.configureCell(with: model, at: indexPath)
            return cell
        }
        
        collectionView?.supplementaryViewProvider { collectionView, model, kind, indexPath in
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
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            let items = models.chunked(into: max(models.count / 2, 1))
            self.collectionView.content {
                DiscoverFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: items.last ?? [])
            }
        }.store(in: &cancellables)
    }
}
