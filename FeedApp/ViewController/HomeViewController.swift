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
            let cell: ArtworkCell = collectionView.configureCell(with: model, at: indexPath)
            return cell
        }
        
        collectionView?.supplementaryViewProvider { collectionView, model, kind, indexPath in
            
            switch model {
            case .popular:
                collectionView.registerHeader(StoriesSnippetWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesSnippetWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return header
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return UICollectionReusableView()
            }
        }
    }
    
    override func updateUI() {
        
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                HomeFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}

enum Marvel {
    case one
}


class MarvelFeedViewController: GenericFeedViewController<MarvelFeedViewController.MarvelFeed, MarvelRemote>  {
    
    typealias MarvelFeed = GenericSectionIdentifierViewModel<Marvel, ComicViewModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remote.fetchComics()
        
        collectionView?.cellProvider { collectionView, indexPath, model in
            let cell: ArtworkCell = collectionView.configureCell(with: model, at: indexPath)
            return cell
        }
        
        remote.$comicViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView?.content {
                MarvelFeed(sectionIdentifier: .one, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}


//// TODO:
//enum NewWay<Section: SectionIdentifierViewModel>: Hashable {
//    
//    static func == (lhs: NewWay<Section>, rhs: NewWay<Section>) -> Bool {
//        
//        switch (lhs, rhs) {
//        case (lhs.identifier, rhs.identifier): return lhs.identifier == rhs.identifier
//            
//        }
//    }
//    
//    
//    case one(Section)
//    case two(Section)
//    case three(Section)
//    
//    var identifier: Section {
//        switch self {
//        case let .one(identifier): return identifier
//        case let .two(identifier): return identifier
//        case let .three(identifier): return identifier
//        }
//    }
//}
