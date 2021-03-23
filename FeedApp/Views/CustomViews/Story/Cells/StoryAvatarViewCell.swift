//
//  StoryAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

final class StoryAvatarViewCell: CollectionViewCell, ViewModelCellInjection {
    
    // MARK:- UI
    private lazy var avatarView: AvatarView = {
        AvatarView()
    }()
    
    // MARK:- ViewModelCellInjection
    var viewModel: Artwork? {
        didSet {
            guard let viewModel = viewModel else { return }
            avatarView.setUpWith(viewModel, border: .gradient(lineWidth: 2.0))
        }
    }
    
    // MARK:- LifeCycle
    override func setupSubviews() {
        contentView.addSubview(avatarView)
        avatarView.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.cleanAndReuse()
    }
}
