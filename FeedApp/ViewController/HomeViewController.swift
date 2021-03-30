//
//  HomeViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine
import UIKit
import MarvelClient

// MARK:- Home Feed Diffable Section Identifier
enum HomeFeedSectionIdentifier: String, CaseIterable {
    case popular = "Popular"
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the Home feed.
typealias HomeFeedSectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel>

final class HomeViewController: GenericFeedViewController<HomeFeedSectionModel, ItunesRemote> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView?.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
        
        collectionView?.supplementaryViewProvider { collectionView, model, kind, indexPath in
            guard let model = model else { return nil }
            switch model {
            case .popular:
                let reusableView: HomeFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                reusableView.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return reusableView
            }
        }
    }
    
    override func updateUI() {
        
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView?.content {
                HomeFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}

