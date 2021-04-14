//
//  UserProfileViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import Foundation
import Combine
import UIKit

// MARK:- User profile Feed Diffable Section Identifier
enum UserProfileFeedIdentifier: String, CaseIterable {
    case headerInfo
    case mainContent
}

// MARK:- Protocol
protocol UserProfileViewControllerDelegate: AnyObject {
    func postSelectedAt(_ indexPath: IndexPath)
    func updateFeed(with feed: [FeedItemViewModel]) // updates the current instantiated controller. // TODO:- consider using combine and using a data base layer to store feed urls.
}

final class UserProfileViewController: GenericFeedViewController<UserProfileViewController.SectionModel, ItunesRemote> {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the User Profile  feed.
    typealias SectionModel = GenericSectionIdentifierViewModel<UserProfileFeedIdentifier, FeedItemViewModel>

    lazy private var detailFeedViewController: FeedViewController = {
        let feedItems = userFeedItems
        let detailFeedViewController = FeedViewController(feed: feedItems)
        delegate = detailFeedViewController
        return detailFeedViewController
    }()
    
    /// - returns: an array of arrays of `FeedItemViewModel` objects
    private var userFeedItems: [FeedItemViewModel] { collectionView.dataSourceFlatCellIdentifiers }
    
    weak var delegate: UserProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVSeasons(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
        
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            switch model {
            case .headerInfo:
                collectionView.registerHeader(CollectionReusableViewContainer<ProfileInfoView>.self, kind: kind)
                let header: CollectionReusableViewContainer<ProfileInfoView> = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.configureContent {
                    $0.fillSuperview()
                    $0.setupWith(UserProfileViewModel.stub)
                }
                return header
            case .mainContent:
                let header: UserProfileFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                return header
            }
        }
        
        collectionView.selectedContentAtIndexPath = { [weak self] viewModel, indexPath in
            guard let self = self else { return }
            guard let secondaryContentNavigationController = self.splitViewController?.secondaryViewController as? NavigationController,
                  let _ = secondaryContentNavigationController.topViewController as? FeedViewController else {
                /// Embeds a `FeedViewController` in a `NavigationController` and shows it if was not shown already.
                let detailNavigationController = NavigationController(rootViewController: self.detailFeedViewController)
                self.splitViewController?.showDetailInNavigationControllerIfNeeded(detailNavigationController, sender: self)
                /// Scrolls the feed to the selected indexpath item.
                self.delegate?.updateFeed(with: self.userFeedItems)
                self.delegate?.postSelectedAt(indexPath)
                return
            }
            
            self.delegate?.updateFeed(with: self.userFeedItems)
            self.delegate?.postSelectedAt(indexPath)
        }
    }
    
    override func updateUI() {
        remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                SectionModel(sectionIdentifier: .headerInfo, cellIdentifiers: [])
                SectionModel(sectionIdentifier: .mainContent, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}
