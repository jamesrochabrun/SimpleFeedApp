//
//  StoriesSnippetWithAvatarCollectionReusableView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import MarvelClient
import Combine

enum StoriesSnippetSectionIdentifier {
    case recent
    case past
}

// MARK:- Section ViewModel
// document
typealias UserStoriesSnippetWithAvatarSectionModeling = GenericSectionIdentifierViewModel<StoriesSnippetSectionIdentifier, CharacterViewModel, StorySnippetWithAvatarViewCell>

final class StoriesSnippetWithAvatarCollectionReusableView: GenericCollectionReusableView<UserStoriesSnippetWithAvatarSectionModeling, HomeFeedSectionIdentifier>  {
    
    override func initialize() {
        super.initialize()
        marvelProvider.fetchCharacters()
    }
    
    override func setupWith(_ viewModel: HomeFeedSectionIdentifier) {
        cancellable = marvelProvider.$characterViewModels.sink { [weak self] in
            let homeFeedSectionItems = [UserStoriesSnippetWithAvatarSectionModeling(sectionIdentifier: .recent, cellIdentifiers: $0)]
           self?.collectionView?.applyInitialSnapshotWith(homeFeedSectionItems)
        }
    }
}


class GenericCollectionReusableView<DiffableContent: SectionIdentifierViewModel, Item: Hashable>: UICollectionReusableView, ViewModelReusableViewInjection {
       
    typealias ViewModel = Item
    var viewModel: ViewModel? {
        didSet {
            setupWith(viewModel!)
        }
    }
    var marvelProvider = MarvelRemote()
    var cancellable: AnyCancellable?
    
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.layout = layout
        }
    }
    
    typealias CollectionView = DiffableCollectionView<DiffableContent>
    var collectionView: CollectionView! // document

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        collectionView = CollectionView()
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    func setupWith(_ viewModel: ViewModel) {
    }
}
