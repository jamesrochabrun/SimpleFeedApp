//
//  StoriesSnippetWithAvatarCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import MarvelClient
import Combine

// MARK:- Stories Snippet Diffable Section Identifier
enum StoriesSnippetSectionIdentifier {
    case recent
    case past
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the Stories Snippet feed.
typealias UserStoriesSnippetWithAvatarSectionModeling = GenericSectionIdentifierViewModel<StoriesSnippetSectionIdentifier, CharacterViewModel, StorySnippetWithAvatarViewCell>

final class StoriesSnippetWithAvatarCollectionReusableView: GenericMarvelItemsCollectionReusableView<UserStoriesSnippetWithAvatarSectionModeling, HomeFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
    }
    
    override func setupWith(_ viewModel: HomeFeedSectionIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `HomeFeedSectionIdentifier` case.
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] in
            let homeFeedSectionItems = [UserStoriesSnippetWithAvatarSectionModeling(sectionIdentifier: .recent, cellIdentifiers: $0)]
           self?.collectionView?.applyInitialSnapshotWith(homeFeedSectionItems)
        }
    }
}


