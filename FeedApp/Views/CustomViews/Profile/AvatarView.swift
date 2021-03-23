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
        imageViewLoader.imageViewContentMode = .scaleAspectFit
        return imageViewLoader
    }()
    
    override func setupViews() {
        addSubview(borderContainer)
        borderContainer.fillSuperview()
        borderContainer.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
    }
    
    func setUpWith(_ artwork: Artwork, border: BorderKind = .none) {
        imageViewLoader.load(regularURL: artwork.imageURL, lowResURL: artwork.thumbnailURL, placeholder: UIImage(named: "person"))
        updateBorderKind(border)
    }
    
    func updateBorderKind(_ kind: BorderKind) {
        layoutIfNeeded()
        borderKind = kind
        switch kind {
        case let .gradient(lineWidth):
            print(frame)
            borderContainer.setupGradient(cornerRadius: frame.size.width / 2.0, lineWidth: lineWidth, frame: frame)
            borderContainer.circle()
        default:
            borderContainer.circle(frame)
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
    }
}
