//
//  ArtworkCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine
import MarvelClient

protocol ArtworkCellChildDragable: AnyObject {
    var target: UIView { get }
}


final class ArtworkCell: CollectionViewCell, ViewModelCellConfiguration  {

    // MARK:- UI
    private lazy var imageViewLoader: ImageViewLoader = {
        let loader = ImageViewLoader()
        loader.delegate = self
        return loader
    }()
    
    weak var delegate: ArtworkCellChildDragable?
    
    // MARK:- Life Cycle
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewLoader.cleanAndReuse()
    }
    
    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: Artwork) {
        let regularURL = viewModel.imageURL
        let lowResURL = viewModel.thumbnailURL
        let placeholder = UIImage(named: "photo")
        imageViewLoader.delegate = self
        imageViewLoader.load(regularURL: regularURL, lowResURL: lowResURL, placeholder: placeholder)
    }
}

extension ArtworkCell: ImageViewLoaderDraggable {
    var target: UIView {
        delegate!.target
        
    }
}
