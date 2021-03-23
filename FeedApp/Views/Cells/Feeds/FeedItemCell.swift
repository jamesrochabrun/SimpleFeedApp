//
//  FeedItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//


import UIKit

final class FeedItemCell: CollectionViewCell, ViewModelCellInjection {
    
    // MARK:- UI
    lazy private var feedItemHeaderView: FeedItemHeaderView = {
        FeedItemHeaderView()
    }()
    
    lazy private var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        imageViewLoader.translatesAutoresizingMaskIntoConstraints = false
        return imageViewLoader
    }()
    
    // MARK:- ViewModelCellInjection
    public var viewModel: FeedItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setUpWith(viewModel)
        }
    }
    
    // MARK:- LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: Use split view controller is compact values perform this update.
        let shouldHide = frame.width < 300
        feedItemHeaderView.isHidden = shouldHide
    }
    
    override func setupSubviews() {

        let stackView = UIStackView(arrangedSubviews: [feedItemHeaderView, imageViewLoader])
        stackView.axis = .vertical
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        stackView.fillSuperview()
        
        feedItemHeaderView.constrainHeight(constant: 80)
        imageViewLoader.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        imageViewLoader.heightAnchor.constraint(equalTo: imageViewLoader.widthAnchor).isActive = true
    }
    
    // MARK:- Configuration
    private func setUpWith(_ viewModel: FeedItemViewModel) {
        // Dummy data
        let userProfileDummyData = HorizontalFeedItemViewModel(user: UserProfileViewModel.stub, location: "Somewhere in the universe", kind: .header)
        feedItemHeaderView.setupWith(userProfileDummyData)
        imageViewLoader.load(regularURL: viewModel.imageURL, lowResURL: viewModel.thumbnailURL, placeholder: UIImage(named: "zizou"))
    }
}
