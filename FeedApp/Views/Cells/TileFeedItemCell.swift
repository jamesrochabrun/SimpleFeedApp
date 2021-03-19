//
//  TileFeedItemCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine
import MarvelClient


extension CharacterViewModel: Artwork {
    
    public var imageURL: String? { artwork?.imagePathFor(variant: .squareStandardLarge) }
    public var thumbnailURL: String? { artwork?.imagePathFor(variant: .squareStandardSmall) }
}



public protocol CellViewModel: UICollectionViewCell {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

open class CollectionViewCell: UICollectionViewCell {
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubviews()
    }
    
    // To be overriden. Super does not need to be called.
    open func setupSubviews() {
    }
}

open class ArtworkCell: CollectionViewCell, CellViewModel {
    
    public var viewModel: Artwork? {
        didSet {
//            assert(viewModel != nil && viewModel is CharacterViewModel, "View Model can not be nil")
            update(viewModel!)
        }
    }
    private lazy var imageViewLoader: ImageViewLoader = {
        ImageViewLoader()
    }()
    public typealias ViewModel = Artwork
    
    open override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
        imageViewLoader.layer.borderColor = UIColor.red.cgColor
        imageViewLoader.layer.borderWidth = 3.0
    }
    
    func update(_ artwork: Artwork) {
        imageViewLoader.load(regularURL: artwork.imageURL!, lowResURL: artwork.thumbnailURL!)
    }
}


public protocol Artwork {
    var imageURL: String? { get }
    var thumbnailURL: String? { get }
}
