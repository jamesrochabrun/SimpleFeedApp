//
//  ImageViewLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine

final class ImageViewLoader: BaseView, ContentReusable {
    
    private lazy var imageLoader: ImageLoader = {
        ImageLoader()
    }()
    
    var imageViewContentMode: UIView.ContentMode  = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageViewContentMode
        }
    }
    
    private var cancellable: AnyCancellable?

//    private var cancellables: Set<AnyCancellable> = []

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        cancellable = imageLoader.$image.sink { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    func load(regularURL: String, lowResURL: String, placeholder: UIImage? = UIImage(systemName: "photo")) {
        imageLoader.load(regularURL, lowResPath: lowResURL, placeholder: placeholder)
    }
    
    func cleanAndReuse() {
//        cancellable?.cancel()
        imageView.image = nil
    }
}
