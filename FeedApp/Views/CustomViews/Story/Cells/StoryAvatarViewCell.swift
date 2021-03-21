//
//  StoryAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

final class StoryAvatarViewCell: CollectionViewCell, ViewModelCellInjection {
    
    private lazy var avatarView: AvatarView = {
        AvatarView()
    }()
    
    var viewModel: Artwork? {
        didSet {
            avatarView.setUpWith(viewModel!, border: .gradient(lineWidth: 4.0))
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(avatarView)
        avatarView.fillSuperview()
    }
}
