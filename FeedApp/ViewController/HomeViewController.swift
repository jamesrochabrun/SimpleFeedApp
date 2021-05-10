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
enum HomeFeedSectionIdentifier {
    case popular
    case adds
}

final class HomeViewController: GenericFeedViewController<HomeViewController.SectionModel, ItunesRemote>, Coordinating {
    
    // MARK:- Coordinator
    weak var coordinator: HomeCoordinator?
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Home feed.
    typealias SectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel>

    private lazy var showMoreButtonItem: UIBarButtonItem = {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(toggleAddsHeaderDisplay))
        leftBarButtonItem.tintColor = Theme.buttonTint.color
        return leftBarButtonItem
    }()

    private var isAddSectionInserted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = showMoreButtonItem
    }
    
    @objc
    private func toggleAddsHeaderDisplay() {
        isAddSectionInserted = !isAddSectionInserted
        showMoreButtonItem.image = UIImage(systemName: isAddSectionInserted ? "minus" : "plus")
        isAddSectionInserted ? collectionView.insertSections([.adds], before: .popular) : collectionView.deleteSection(.adds)
    }
    
    override func fetchData() {
        remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView.cellProvider { collectionView, indexPath, model in
            let cell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
            cell.delegate = self
            return cell
        }
        
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            switch model {
            case .popular, .adds:
                return collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath) as HomeFeedSupplementaryView
            }
        }
        
        collectionView.selectedContentAtIndexPath = { [weak self] viewModel, _ in
            /// Pas an image?
        }
    }
    
    override func updateUI() {
        
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                SectionModel(sectionIdentifier: .popular, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}

extension HomeViewController: ArtworkCellChildDragable {
    var target: UIView {
        self.navigationController!.navigationBar
    }
}
