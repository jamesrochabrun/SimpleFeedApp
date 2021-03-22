//
//  NotificationsViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit
//
final class NotificationItemCell: CollectionViewCell, ViewModelCellInjection {
    
    var viewModel: HorizontalFeedItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupWith(viewModel)
        }
    }
    
    override func setupSubviews() {
        
    }
    private lazy var feedItemHeaderView: FeedItemHeaderView = {
        FeedItemHeaderView()
    }()
    
    func setupWith(_ viewModel: HorizontalFeedItemViewModel) {
    }
}

// MARK:- User profile Feed Diffable Section Identifier
enum NotificationsFeedIdentifier: String, CaseIterable {
    case important
}

// MARK:- Section ViewModel
/// - Typealias that describes the structure of a section in the User Profile  feed.
typealias NotificationsSectionModeling = GenericSectionIdentifierViewModel<UserProfileFeedIdentifier, HorizontalFeedItemViewModel, NotificationItemCell>


final class NotificationsViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


