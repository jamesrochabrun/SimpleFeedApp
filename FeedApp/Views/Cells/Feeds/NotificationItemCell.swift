//
//  NotificationItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

final class NotificationItemCell: CollectionViewCell, ViewModelCellConfiguration {
    
    // MARK:- UI
    private lazy var feedItemHeaderView: FeedItemHeaderView = {
        FeedItemHeaderView()
    }()
    
    // MARK:- Life Cycle
    override func setupSubviews() {
        contentView.addSubview(feedItemHeaderView)
        feedItemHeaderView.fillSuperview()
    }
    
    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: HorizontalFeedItemViewModel) {
        feedItemHeaderView.setupWith(viewModel)
    }
}
