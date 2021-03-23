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
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the User Profile  feed.
typealias UserProfileSectionModel = GenericSectionIdentifierViewModel<UserProfileFeedIdentifier, FeedItemViewModel, ArtworkCell>

final class UserProfileViewController: GenericFeedViewController<UserProfileSectionModel, ItunesRemote> {
    
    lazy private var detailFeedViewController: FeedViewController<UserProfileSectionModel> = {
        let detailFeedViewController = FeedViewController<UserProfileSectionModel>()
        detailFeedViewController.feed = collectionView.dataSourceItems()
        delegate = detailFeedViewController
        return detailFeedViewController
    }()
    
    weak var delegate: UserProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = nil
    }

    override func fetchData() {
        remote.fetch(.tvShows(feedType: .topTVSeasons(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath -> UICollectionReusableView in
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
                collectionView.registerHeader(StoriesWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                return header
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return UICollectionReusableView()
            }
        }
        
        collectionView.selectedContentAtIndexPath = { [weak self] viewModel, indexPath in
            guard let self = self else { return }
            guard let secondaryContentNavigationController = self.splitViewController?.secondaryViewController as? NavigationController,
                  let secondaryContentViewController = secondaryContentNavigationController.topViewController as? FeedViewController<UserProfileSectionModel> else {
                /// Embeds a `FeedViewController` in a `NavigationController` and shows it if was not shown already.
                let detailNavigationController = NavigationController(rootViewController: self.detailFeedViewController)
                self.splitViewController?.showDetailInNavigationControllerIfNeeded(detailNavigationController, sender: self)
                /// Scrolls the feed to the selected indexpath item.
                self.delegate?.postSelectedAt(indexPath)
                return
            }
            /// Optimization -> Shows the already instantiated `FeedViewController`
            self.splitViewController?.showDetailInNavigationControllerIfNeeded(secondaryContentViewController, sender: self)
            self.delegate?.postSelectedAt(indexPath)
        }
    }
    
    override func updateUI() {
        
        remote.$sectionFeedViewModels.sink { [weak self] in
            let profileContentSection = UserProfileSectionModel(sectionIdentifier: .headerInfo, cellIdentifiers: [])
            let homeFeedMainContentSection = UserProfileSectionModel(sectionIdentifier: .mainContent, cellIdentifiers: $0)
            self?.collectionView.applyInitialSnapshotWith([profileContentSection, homeFeedMainContentSection])
        }.store(in: &cancellables)
    }
}
