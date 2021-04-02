//
//  HomeFeedSupplementaryView.swift
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

final class HomeFeedSupplementaryView: GenericFeedCollectionReusableView<HomeFeedSupplementaryView.SectionModel, MarvelRemote, HomeFeedSectionIdentifier>  {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Stories Snippet feed.
    typealias SectionModel = GenericSectionIdentifierViewModel<StoriesSnippetSectionIdentifier, ArtworkViewModel>
    
    override func initialize() {
        super.initialize()
        layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
        marvelProvider.fetchComics()
        marvelProvider.fetchSeries()
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as StorySnippeCell
        }
    }
    
    override func setupWith(_ viewModel: HomeFeedSectionIdentifier) {
        switch viewModel {
        case .popular:
            marvelProvider.$comicViewModels.sink { [weak self] models in
                guard let self = self else { return }
                self.collectionView.content {
                    SectionModel(sectionIdentifier: .recent, cellIdentifiers: models.map { $0.artwork })
                }
            }.store(in: &cancellables)
        case .adds:
            marvelProvider.$serieViewModels.sink { [weak self] models in
                guard let self = self else { return }
                dump(models)
                self.collectionView.content {
                    SectionModel(sectionIdentifier: .recent, cellIdentifiers: models.map { $0.artwork })
                }
            }.store(in: &cancellables)
        }
    }
}


