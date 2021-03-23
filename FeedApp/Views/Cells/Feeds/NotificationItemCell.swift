//
//  NotificationItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

final class NotificationItemCell: CollectionViewCell, ViewModelCellInjection {
    
    // MARK:- ViewModelCellInjection
    var viewModel: HorizontalFeedItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupWith(viewModel)
        }
    }
    // MARK:- UI
    private lazy var feedItemHeaderView: FeedItemHeaderView = {
        FeedItemHeaderView()
    }()
    
    override func setupSubviews() {
        contentView.addSubview(feedItemHeaderView)
        feedItemHeaderView.fillSuperview()
    }

    // MARK:- Configuration
    func setupWith(_ viewModel: HorizontalFeedItemViewModel) {
        feedItemHeaderView.setupWith(viewModel)
    }
}
