//
//  StorySnippetWithAvatarViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/20/21.
//

import UIKit
import MarvelClient
    
final class StorySnippetWithAvatarViewCell: CollectionViewCell, ViewModelCellInjection {
    
    var viewModel: CharacterViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setUpWith(viewModel)
        }
    }
    
    static let profileCoverSize: CGSize = .init(width: 55.0, height: 55.0)

    private lazy var imageViewLoader: ImageViewLoader = {
        let imageViewLoader = ImageViewLoader()
        imageViewLoader.clipsToBounds = true
        imageViewLoader.imageViewContentMode = .scaleAspectFill
        return imageViewLoader
    }()
    
    private lazy var avatarView: AvatarView = {
        AvatarView()
    }()
    
    private lazy var bottomGradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect.zero
       return gradientLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomGradient.frame = .init(x: 0, y: frame.height - Self.profileCoverSize.height, width: frame.width, height: Self.profileCoverSize.height)
    }
    
    override func setupSubviews() {
        contentView.addSubview(imageViewLoader)
        imageViewLoader.fillSuperview()
        contentView.addSubview(avatarView)
        avatarView.anchor(bottom: contentView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: Self.profileCoverSize)
        avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        layoutIfNeeded()
        imageViewLoader.layer.addSublayer(bottomGradient)
    }
    
    private func setUpWith(_ viewModel: CharacterViewModel) {
        imageViewLoader.load(regularURL: viewModel.artwork?.imagePathFor(variant: .portraitIncredible) ?? "", lowResURL: viewModel.artwork?.imagePathFor(variant: .portraitMedium) ?? "", placeholder: UIImage(named: "sparkles"))
        avatarView.setUpWith(viewModel, border: .gradient(lineWidth: 3))
    }
}
