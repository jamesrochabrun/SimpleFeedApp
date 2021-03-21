//
//  UserProfileViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import Foundation
import Combine
import UIKit

protocol ContentReusable: UIView {
    func cleanAndReuse()
}

final class CollectionReusableView<Content: ContentReusable>: CollectionViewReusableView, ViewModelReusableViewInjection {
    
    var viewModel: String?
    
    let subView: Content = {
        Content()
    }()
    override func setupSubviews() {
        addSubview(subView)
        subView.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subView.cleanAndReuse()
    }
}

final class CollectionContentViewCell<Content: ContentReusable & ViewModelViewInjection>: CollectionViewCell, ViewModelCellInjection {
    
    var viewModel: Content.ViewModel? {
        didSet {
            subView.viewModel = viewModel 
        }
    }
    
    let subView: Content = {
        Content()
    }()
    
    override func setupSubviews() {
        addSubview(subView)
        subView.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subView.cleanAndReuse()
    }
}

public enum UserProfileFeedIdentifier: String, CaseIterable {
    case headerInfo
    case mainContent
}

// MARK:- Protocol
protocol UserProfileViewControllerDelegate: AnyObject {
    func postSelectedAt(_ indexPath: IndexPath)
}

private typealias UserProfileSectionModeling = GenericSectionIdentifierViewModel<UserProfileFeedIdentifier, FeedItemViewModel, ArtworkCell>

final class UserProfileViewController: ViewController {
    
    // MARK:- Data
    private var cancellables: Set<AnyCancellable> = []
    private let itunesRemote = ItunesRemote()
    
    // MARK:- typealias
    private typealias UserFeedCollectionView = DiffableCollectionView<UserProfileSectionModeling>
    
    // MARK:- UI
    private lazy var userFeedCollectionView: UserFeedCollectionView = {
        let userFeed = UserFeedCollectionView()
        userFeed.layout = GridLayoutKind.profile.layout
        return userFeed
    }()
    
    lazy private var detailFeedViewController: FeedViewController<UserProfileSectionModeling> = {
        let detailFeedViewController = FeedViewController<UserProfileSectionModeling>()
        detailFeedViewController.feed = userFeedCollectionView.dataSourceItems()
        delegate = detailFeedViewController
        return detailFeedViewController
    }()
    
    weak var delegate: UserProfileViewControllerDelegate?
    
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
        view.addSubview(userFeedCollectionView)
        userFeedCollectionView.fillSuperview()
        userFeedCollectionView.selectedContentAtIndexPath = { [weak self] viewModel, indexPath in
            guard let self = self else { return }
            guard let secondaryContentNavigationController = self.splitViewController?.secondaryViewController as? NavigationController,
                  let secondaryContentViewController = secondaryContentNavigationController.topViewController as? FeedViewController<UserProfileSectionModeling> else {
                let detailNavigationController = NavigationController(rootViewController: self.detailFeedViewController)
                self.splitViewController?.showDetailInNavigationControllerIfNeeded(detailNavigationController, sender: self)
                self.delegate?.postSelectedAt(indexPath)
                return
            }
            self.splitViewController?.showDetailInNavigationControllerIfNeeded(secondaryContentViewController, sender: self)
            self.delegate?.postSelectedAt(indexPath)
        }
        
        userFeedCollectionView.assignHedearFooter { collectionView, model, kind, indexPath -> UICollectionReusableView in
            switch model {
            case .headerInfo:
                collectionView.registerHeader(CollectionReusableView<ProfileInfoView>.self, kind: kind)
                let header: CollectionReusableView<ProfileInfoView> = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.subView.setupWith(UserProfileViewModel.stub)
                return header
            case .mainContent:
                collectionView.registerHeader(StoriesWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = .popular
                header.layout = HorizontalLayoutKind.horizontalStoryUserCoverLayout(itemWidth: 100.0).layout
                return header
            default: fatalError() // should not get executed
            }
        }
    }
    
    private func performOperations() {
        itunesRemote.fetch(.podcast(feedType: .top(genre: .all), limit: 100))
    }
    
    private func updateUI() {

        itunesRemote.$sectionFeedViewModels.sink { [weak self] in
            let profileContentSection = UserProfileSectionModeling(sectionIdentifier: .headerInfo, cellIdentifiers: [])
            let homeFeedMainContentSection = UserProfileSectionModeling(sectionIdentifier: .mainContent, cellIdentifiers: $0)
            self?.userFeedCollectionView.applyInitialSnapshotWith([profileContentSection, homeFeedMainContentSection])
        }.store(in: &cancellables)
    }
}
