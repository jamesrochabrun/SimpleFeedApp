//
//  StoriesWithAvatarCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit
import Combine
import MarvelClient

enum UserStoriesSectionIdentifier {
    case closeFriends
    case everyone
}

// MARK:- Section ViewModel
// document
typealias UserStoriesWithAvatarSectionModeling = GenericSectionIdentifierViewModel<UserStoriesSectionIdentifier, CharacterViewModel, StoryAvatarViewCell>


final class StoriesWithAvatarCollectionReusableView: GenericCollectionReusableView<UserStoriesWithAvatarSectionModeling, DiscoverFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
    }
    
    override func setupWith(_ viewModel: DiscoverFeedSectionIdentifier) {
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] in
            let homeFeedSectionItems = [UserStoriesWithAvatarSectionModeling(sectionIdentifier: .everyone, cellIdentifiers: $0)]
           self?.collectionView?.applyInitialSnapshotWith(homeFeedSectionItems)
        }
    }
}
