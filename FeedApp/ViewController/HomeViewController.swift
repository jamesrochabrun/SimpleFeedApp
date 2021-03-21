//
//  HomeViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine
import UIKit

enum HomeFeedSectionIdentifier: String, CaseIterable {
    case popular = "Popular"
}

// MARK:- Section ViewModel
// document
private typealias HomeFeedSectionModeling = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>

final class HomeViewController: ViewController {
    
    // MARK:- Data
    private var cancellables: Set<AnyCancellable> = []
    private let itunesRemote = ItunesRemote()
    
    // MARK:- typealias
    private typealias HomeFeedCollectionView = DiffableCollectionView<HomeFeedSectionModeling>
    
    // MARK:- UI
    private lazy var homeFeedCollectionView: HomeFeedCollectionView = {
        let homeFeed = HomeFeedCollectionView()
        homeFeed.layout = GridLayoutKind.home.layout
        return homeFeed
    }()
    
    // MARK:- Life Cycle
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
        view.addSubview(homeFeedCollectionView)
        homeFeedCollectionView.fillSuperview()
        
        homeFeedCollectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
                collectionView.registerHeader(StoriesSnippetWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesSnippetWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = model
                header.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return header
            default: fatalError() // should not get executed
            }
        }
    }
    
    private func performOperations() {
        itunesRemote.fetch(.itunesMusic(feedType: .newMusic(genre: .all), limit: 100))
    }
    
    private func updateUI() {
        
        itunesRemote.$sectionFeedViewModels.sink { [weak self] in
            let homeFeedSectionItems = [HomeFeedSectionModeling(sectionIdentifier: .popular, cellIdentifiers: $0)]
            self?.homeFeedCollectionView.applyInitialSnapshotWith(homeFeedSectionItems)
        }.store(in: &cancellables)
    }
}
