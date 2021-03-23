//
//  HomeViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine
import UIKit

// MARK:- Home Feed Diffable Section Identifier
enum HomeFeedSectionIdentifier: String, CaseIterable {
    case popular = "Popular"
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the Home feed.
typealias HomeFeedSectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>

final class HomeViewController: GenericFeedViewController<HomeFeedSectionModel, ItunesRemote> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                collectionView.registerHeader(StoriesSnippetWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesSnippetWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = model
                header.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return header
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return UICollectionReusableView()
            }
        }
    }
    
    override func updateUI() {
        
        remote.$sectionFeedViewModels.sink { [weak self] in
            let homeFeedSectionItems = [HomeFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: $0)]
            self?.collectionView.applyInitialSnapshotWith(homeFeedSectionItems)
        }.store(in: &cancellables)
    }
}
