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

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the Stories feed.
typealias UserStoriesWithAvatarSectionModel = GenericSectionIdentifierViewModel<UserStoriesSectionIdentifier, CharacterViewModel>

final class DiscoveryFeedSupplementaryView: GenericMarvelItemsCollectionReusableView<UserStoriesWithAvatarSectionModel, DiscoverFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
        collectionView?.cellProvider { collectionView, indexPath, model in
            let cell: StoryAvatarViewCell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath)
            return cell
        }
    }
    
    override func setupWith(_ viewModel: DiscoverFeedSectionIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `DiscoverFeedSectionIdentifier` case.
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView?.content {
                UserStoriesWithAvatarSectionModel(sectionIdentifier: .everyone, cellIdentifiers: models)
            }
        }
    }
}

