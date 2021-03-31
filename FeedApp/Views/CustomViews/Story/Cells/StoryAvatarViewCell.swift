//
//  StoryAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit
//
final class StoryAvatarViewCell: CollectionViewCell, ViewModelCellConfiguration {

    // MARK:- UI
    private lazy var avatarView: AvatarView = {
        AvatarView()
    }()

    // MARK:- LifeCycle
    override func setupSubviews() {
        contentView.addSubview(avatarView)
        avatarView.fillSuperview()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.cleanAndReuse()
    }
    
    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: Artwork) {
        avatarView.setUpWith(viewModel, border: .gradient(lineWidth: 2.0))
    }
}
