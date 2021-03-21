//
//  ArtworkCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine
import MarvelClient

open class ArtworkCell: CollectionViewCell, ViewModelCellInjection {
    
    public var viewModel: Artwork? {
        didSet {
            setUpWith(viewModel!)
        }
    }
    private lazy var imageViewLoader: ImageViewLoader = {
        ImageViewLoader()
    }()
    
    open override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    private func setUpWith(_ artwork: Artwork) {
        imageViewLoader.load(regularURL: artwork.imageURL!, lowResURL: artwork.thumbnailURL!)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        imageViewLoader.cleanAndReuse()
    }
}
