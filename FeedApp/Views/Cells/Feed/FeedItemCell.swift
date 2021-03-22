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
        let stackView = UIStackView(arrangedSubviews: [feedItemHeaderView, imageViewLoader])
        stackView.axis = .vertical
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       // stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
      //  bottomConstraint.priority = UILayoutPriority(999.0)
        bottomConstraint.isActive = true
        
    }
    
    private func setUpWith(_ viewModel: FeedItemViewModel) {
        
        feedItemHeaderView.setupWith(HorizontalFeedItemViewModel(user: UserProfileViewModel.stub, location: "Somewhere in the universe", kind: .header))
        imageViewLoader.load(regularURL: viewModel.imageURL, lowResURL: viewModel.thumbnailURL, placeholder: UIImage(named: "zizou"))
    }
}
