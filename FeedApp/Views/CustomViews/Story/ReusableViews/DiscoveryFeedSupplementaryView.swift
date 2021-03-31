//
//  DiscoveryFeedSupplementaryView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit
import Combine
import MarvelClient

// MARK:- User Stories Section Identifier
enum UserStoriesSectionIdentifier {
    case closeFriends
    case everyone
}

final class DiscoveryFeedSupplementaryView: GenericMarvelItemsCollectionReusableView<DiscoveryFeedSupplementaryView.UserStoriesWithAvatarSectionModel, DiscoverFeedSectionIdentifier>  {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Stories feed.
    typealias UserStoriesWithAvatarSectionModel = GenericSectionIdentifierViewModel<UserStoriesSectionIdentifier, CharacterViewModel>

    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as StoryAvatarViewCell
        }
    }
    
    override func setupWith(_ viewModel: DiscoverFeedSectionIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `DiscoverFeedSectionIdentifier` case.
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                UserStoriesWithAvatarSectionModel(sectionIdentifier: .everyone, cellIdentifiers: models)
            }
        }
    }
}

