//
//  FeedItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//


import UIKit

final class FeedItemCell: CollectionViewCell, ViewModelCellConfiguration {
    
    @IBOutlet private var feedItemHeaderView: FeedItemAvatarView!
    @IBOutlet private var imageViewLoader: ImageViewLoader!

    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: FeedItemViewModel) {
        // Dummy User data
        let userProfileDummyData = HorizontalFeedItemViewModel(user: UserProfileViewModel.stub, location: "Somewhere in the universe", kind: .header)
        feedItemHeaderView.setupWith(userProfileDummyData)
        imageViewLoader.load(regularURL: viewModel.imageURL, lowResURL: viewModel.thumbnailURL, placeholder: UIImage(named: "zizou"))
    }
    
    // MARK:- LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedItemHeaderView?.cleanAndReuse()
    }
}
