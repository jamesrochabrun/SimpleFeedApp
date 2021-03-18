//
//  SearchViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/16/21.
//

import Foundation
import Combine
import MarvelClient
import UIKit

final class SearchViewController: ViewController {
    
    // MARK:- Data
    private var cancellables: Set<AnyCancellable> = []
    
    private var cancellable: AnyCancellable?

    private var marvelProvider = MarvelProvider()
    // MARK:- Concurrency
    private let operationQueue = OperationQueue()
    
    // MARK:- TypeAlias
    typealias SearchFeedCollectionView = DiffableCollectionView<GenericSectionIdentifierViewModel<SectionIdentifierExample, ComicViewModel, ArtworkCell>>
    
    // MARK:- UI
    private lazy var searchCollectionView: SearchFeedCollectionView = {
        SearchFeedCollectionView(layout: GridLayoutKind.search.layout, parent: nil)
    }()
    
    // MARK:- LifeCycle
    deinit {
        print("DEINIT \(String(describing: self))")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        performOperations()
        updateUI()
    }
    
    private func setupViews() {
        view.addSubview(searchCollectionView)
        searchCollectionView.fillSuperview()
    }
    
    private func performOperations() {
        
        marvelProvider.fetchComics()
        
//        let comicsOperation = BlockOperation { [unowned self] in
//            marvelProvider.fetchComics()
//        }
//        let charactersOperation = BlockOperation { [unowned self] in
//            //  marvelProvider.fetchCharacters()
//        }
//        charactersOperation.addDependency(comicsOperation)
//        operationQueue.addOperation(comicsOperation)
//        operationQueue.addOperation(charactersOperation)
    }
    
    private func updateUI() {
        
        cancellable = marvelProvider.$comics.sink { [unowned self] value in
            searchCollectionView.applySnapshotWith(value)
        }
        searchCollectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                let header: CollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                return header
            default: return fatalError() as! CollectionReusableView // should not get executed
            }
        }
    }
}

extension ComicViewModel: Artwork {
    public var imageURL: String? { artwork.imagePathFor(variant: .squareStandardLarge) }
    public var thumbnailURL: String? { artwork.imagePathFor(variant: .squareStandardSmall) }
}
