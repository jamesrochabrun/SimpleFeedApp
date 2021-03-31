//
//  StorySnippetWithAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import MarvelClient
    
final class StorySnippeCell: CollectionViewCell, ViewModelCellConfiguration {
    
    // MARK:- UI
    private lazy var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        imageViewLoader.clipsToBounds = true
        return imageViewLoader
    }()
    
    // MARK:- LifeCycle
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    // MARK:- ViewModelCellConfiguration
     func configureCell(with viewModel: ComicViewModel) {
        let regularURL = viewModel.artwork.imagePathFor(variant: .portraitIncredible)
        let lowResURL = viewModel.artwork.imagePathFor(variant: .portraitMedium)
        let placeholder = UIImage(named: "sparkles")
        imageViewLoader.load(regularURL: regularURL, lowResURL: lowResURL, placeholder: placeholder)
    }
}
