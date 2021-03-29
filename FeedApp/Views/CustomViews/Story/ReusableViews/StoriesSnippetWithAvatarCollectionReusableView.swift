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
typealias UserStoriesSnippetWithAvatarSectionModeling = GenericSectionIdentifierViewModel<StoriesSnippetSectionIdentifier, ComicViewModel>

final class StoriesSnippetWithAvatarCollectionReusableView: GenericMarvelItemsCollectionReusableView<UserStoriesSnippetWithAvatarSectionModeling, HomeFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchComics()
        
        collectionView?.cellProvider { collectionView, indexPath, model in
            let cell: StorySnippeCell = collectionView.configureCell(with: model, at: indexPath)
            return cell
        }
    }
    
    override func setupWith(_ viewModel: HomeFeedSectionIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `HomeFeedSectionIdentifier` case.
        cancellable = marvelProvider.$comicViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView?.content {
                UserStoriesSnippetWithAvatarSectionModeling(sectionIdentifier: .recent, cellIdentifiers: models)
            }
        }
    }
}


