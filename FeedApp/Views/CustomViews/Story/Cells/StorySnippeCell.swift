//
//  StorySnippetWithAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import MarvelClient
    
final class StorySnippeCell: CollectionViewCell, ViewModelCellInjection {
    
    
    // MARK:- UI
    private lazy var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        imageViewLoader.clipsToBounds = true
        return imageViewLoader
    }()
    
    // MARK:- ViewModelCellInjection
    var viewModel: ComicViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setUpWith(viewModel)
        }
    }
    
    // MARK:- LifeCycle
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    private func setUpWith(_ viewModel: ComicViewModel) {
        imageViewLoader.load(regularURL: viewModel.artwork.imagePathFor(variant: .portraitIncredible), lowResURL: viewModel.artwork.imagePathFor(variant: .portraitMedium), placeholder: UIImage(named: "sparkles"))
    }
}
