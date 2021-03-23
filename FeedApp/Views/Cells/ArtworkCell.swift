//
//  ArtworkCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine
import MarvelClient

final class ArtworkCell: CollectionViewCell, ViewModelCellInjection {
    
    // MARK:- View Model injection
    var viewModel: Artwork? {
        didSet {
            guard let viewModel = viewModel else { return }
            setUpWith(viewModel)
        }
    }
    // MARK:- UI
    private lazy var imageViewLoader: ImageViewLoader = {
        ImageViewLoader()
    }()
    // MARK:- Life Cycle
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewLoader.cleanAndReuse()
    }
    
    // MARK:- Configuration
    private func setUpWith(_ artwork: Artwork) {
        imageViewLoader.load(regularURL: artwork.imageURL, lowResURL: artwork.thumbnailURL, placeholder: UIImage(named: "photo"))
    }
}
