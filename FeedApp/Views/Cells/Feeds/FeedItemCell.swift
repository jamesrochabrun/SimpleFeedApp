//
//  FeedItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//


import UIKit

final class FeedItemCell: CollectionViewCell, ViewModelCellConfiguration {
    
    // MARK:- UI
    lazy private var feedItemHeaderView: FeedItemHeaderView = {
        let f = FeedItemHeaderView()
        f.addBorder(.yellow, width: 5.0)
        return f
    }()
    
    lazy private var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        imageViewLoader.translatesAutoresizingMaskIntoConstraints = false
        return imageViewLoader
    }()
    
    var stackViewcontainer: UIView = {
        UIView()
    }()
    
    var displayMode: UISplitViewController.DisplayMode = .allVisible

    
    // MARK:- LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
        
    override func setupSubviews() {
        
//        contentView.addSubview(feedItemHeaderView)
//        contentView.addSubview(imageViewLoader)
//
//        feedItemHeaderView.anchor(top: contentView.topAnchor,
//                                  leading: contentView.leadingAnchor,
//                                  trailing: contentView.trailingAnchor)
//                                //  size: .init(width: 0, height: 100))
//
//        imageViewLoader.anchor(top: feedItemHeaderView.bottomAnchor,
//                               leading: contentView.leadingAnchor,
//                               bottom: contentView.bottomAnchor,
//                               trailing: contentView.trailingAnchor)
//        imageViewLoader.widthAnchor.constraint(equalTo: imageViewLoader.heightAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [feedItemHeaderView, imageViewLoader])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        contentView.addSubview(stackViewcontainer)
        stackViewcontainer.fillSuperview()

        stackViewcontainer.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
        let bottomAnchor = stackViewcontainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomAnchor.priority = UILayoutPriority(999)
        bottomAnchor.isActive = true

        stackViewcontainer.addSubview(stackView)
        stackView.fillSuperview()
      //  feedItemHeaderView.constrainHeight(constant: 100)
        imageViewLoader.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        imageViewLoader.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: FeedItemViewModel) {
        // Dummy data
        feedItemHeaderView.isHidden = displayMode != .allVisible
        let userProfileDummyData = HorizontalFeedItemViewModel(user: UserProfileViewModel.stub, location: "Somewhere in the universe", kind: .header)
        feedItemHeaderView.setupWith(userProfileDummyData)
        imageViewLoader.load(regularURL: viewModel.imageURL, lowResURL: viewModel.thumbnailURL, placeholder: UIImage(named: "zizou"))
    }
    
}
