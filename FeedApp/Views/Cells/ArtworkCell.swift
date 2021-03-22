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
    
    var viewModel: Artwork? {
        didSet {
            setUpWith(viewModel!)
        }
    }
    private lazy var imageViewLoader: ImageViewLoader = {
        ImageViewLoader()
    }()
    
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    private func setUpWith(_ artwork: Artwork) {
        imageViewLoader.load(regularURL: artwork.imageURL, lowResURL: artwork.thumbnailURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewLoader.cleanAndReuse()
    }
}
