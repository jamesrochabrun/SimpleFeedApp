//
//  FeedItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//


import UIKit

final class FeedItemCell: CollectionViewCell, ViewModelCellInjection {
    
    lazy private var feedItemHeaderView: FeedItemHeaderView = {
        FeedItemHeaderView()
    }()
    
    lazy private var imageViewLoader: ImageViewLoader = {
        ImageViewLoader()
    }()
    
//    lazy private var feedItemActionsView: FeedItemActionsView = {
//        FeedItemActionsView()
//    }()
    
    public var viewModel: FeedItemViewModel? {
        didSet {
            setUpWith(viewModel!)
        }
    }
    
    override func setupSubviews() {
        feedItemHeaderView.constrainHeight(constant: 80)
        imageViewLoader.heightAnchor.constraint(equalTo: imageViewLoader.widthAnchor, multiplier: 1).isActive = true
//        feedItemActionsView.constrainHeight(constant: 80)
        let stackView = UIStackView(arrangedSubviews: [feedItemHeaderView, imageViewLoader])
        stackView.axis = .vertical
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        stackView.fillSuperview()
    }
    
    private func setUpWith(_ viewModel: FeedItemViewModel) {
        
        feedItemHeaderView.setupWith(HeaderPostViewModel(user: UserProfileViewModel.stub, location: "Somewhere in the universe"))
        imageViewLoader.load(regularURL: viewModel.imageURL ?? "", lowResURL: viewModel.thumbnailURL ?? "")
    }
}
