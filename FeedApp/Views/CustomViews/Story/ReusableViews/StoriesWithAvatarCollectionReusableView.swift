//
//  StoriesWithAvatarCollectionReusableView.swift
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
typealias UserStoriesWithAvatarSectionModeling = GenericSectionIdentifierViewModel<UserStoriesSectionIdentifier, CharacterViewModel, StoryAvatarViewCell>

final class StoriesWithAvatarCollectionReusableView: GenericMarvelItemsCollectionReusableView<UserStoriesWithAvatarSectionModeling, DiscoverFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
    }
    
    override func setupWith(_ viewModel: DiscoverFeedSectionIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `DiscoverFeedSectionIdentifier` case.
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] in
            let homeFeedSectionItems = [UserStoriesWithAvatarSectionModeling(sectionIdentifier: .everyone, cellIdentifiers: $0)]
           self?.collectionView?.applyInitialSnapshotWith(homeFeedSectionItems)
        }
    }
}
