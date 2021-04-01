//
//  NotificationsViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit
import MarvelClient
import Combine

// MARK:- User profile Feed Diffable Section Identifier
enum NotificationsFeedIdentifier: String, CaseIterable {
    case important
}

final class NotificationsViewController: GenericFeedViewController<NotificationsViewController.NotificationsSectionModel, MarvelRemote>  {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the User Profile  feed.
    typealias NotificationsSectionModel = GenericSectionIdentifierViewModel<NotificationsFeedIdentifier, HorizontalFeedItemViewModel>

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetchCharacters()
    }
    
    override func setUpUI() {
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as NotificationItemCell
        }
    }
    
    override func updateUI() {
        remote.$characterViewModels.sink { [weak self] characterViewModels in
            guard let self = self else { return }
            let characters = characterViewModels.map { HorizontalFeedItemViewModel(characterViewModel: $0) }
            self.collectionView.content {
                NotificationsSectionModel(sectionIdentifier: .important, cellIdentifiers: characters)
            }
        }.store(in: &cancellables)
    }
}

extension HorizontalFeedItemViewModel {
    
    init(characterViewModel: CharacterViewModel) {
        user = UserProfileViewModel(userAvatarURL: characterViewModel.imageURL, userAvatarPlaceholder: UIImage(named: "person"), userDataStackViewModel: UserDataStackViewModel(photoDataInfo: UserDataViewModel(numberInfo: "", sectionInfoTitle: ""), followersDataInfo: UserDataViewModel(numberInfo: "", sectionInfoTitle: ""), followingDataInfo: UserDataViewModel(numberInfo: "", sectionInfoTitle: "")), profileDescription: UserProfileDescription(userName: characterViewModel.name, userPersonalDescription: characterViewModel.description))
        location = characterViewModel.description
        kind = .list
    }
}
