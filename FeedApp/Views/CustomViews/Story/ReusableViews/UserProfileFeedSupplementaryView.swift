//
//  UserProfileFeedSupplementaryView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/29/21.
//

import Foundation
import MarvelClient

// MARK:- User Stories Section Identifier
enum UserProfileHeaderSectionIdentifier {
    case recent
}

final class UserProfileFeedSupplementaryView: GenericMarvelItemsCollectionReusableView<UserProfileFeedSupplementaryView.SectionModel, UserProfileFeedIdentifier>  {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Stories feed.
    typealias SectionModel = GenericSectionIdentifierViewModel<UserProfileHeaderSectionIdentifier, CharacterViewModel>

    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
        collectionView.cellProvider { collectionView, indexPath, model in
            let cell: StoryAvatarViewCell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath)
            return cell
        }
    }
    
    override func setupWith(_ viewModel: UserProfileFeedIdentifier) {
        // Note: Here we can also customize this collection view with headers, footer, accessories based on the `DiscoverFeedSectionIdentifier` case.
        marvelProvider.$characterViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                SectionModel(sectionIdentifier: .recent, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}
