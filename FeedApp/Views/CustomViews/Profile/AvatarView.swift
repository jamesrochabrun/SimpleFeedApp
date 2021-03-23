//
//  AvatarView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

// used in:
/// - Hilights
/// - Story covers with user avatar
enum BorderKind {
    case gradient(lineWidth: CGFloat)
    case none
}

final class AvatarView: BaseView, ContentReusable {
    
    private var borderKind: BorderKind = .none
    
    private lazy var borderContainer: UIView = {
        UIView()
    }()

    private lazy var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        return imageViewLoader
    }()
    
    override func setupViews() {
        addSubview(borderContainer)
        borderContainer.fillSuperview()
        borderContainer.addSubview(imageViewLoader)
        imageViewLoader.anchor(top: borderContainer.topAnchor,
                               leading: borderContainer.leadingAnchor,
                               bottom: borderContainer.bottomAnchor,
                               trailing: borderContainer.trailingAnchor,
                               padding: .init(top: 7, left: 7, bottom: 7, right: 7))
    }
    
    func setUpWith(_ artwork: Artwork, border: BorderKind = .none) {
        imageViewLoader.load(regularURL: artwork.imageURL, lowResURL: artwork.thumbnailURL, placeholder: UIImage(named: "person"))
        updateBorderKind(border)
    }
    
    func updateBorderKind(_ kind: BorderKind) {
        
        layoutIfNeeded()
        borderContainer.circle()
        imageViewLoader.circle()
        borderKind = kind
        
        switch borderKind {
        case let .gradient(lineWidth):
            borderContainer.setupGradient(cornerRadius: frame.size.width / 2.0, lineWidth: lineWidth, frame: frame)
        default:
            borderContainer.addBorder(Theme.circularBorder.color ?? .clear, width: 2.0)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch borderKind {
        case .none:
            borderContainer.addBorder(Theme.circularBorder.color ?? .clear, width: 2.0)
        default: break
        }
    }
    
    func cleanAndReuse() {
        // Perform any clean up for this view on cell reuse.
    }
}
