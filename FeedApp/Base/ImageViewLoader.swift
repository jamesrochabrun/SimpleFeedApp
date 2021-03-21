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
        cancellable = imageLoader.$image.sink { [unowned self] image in
            imageView.image = image
        }
    }
    
    func load(regularURL: String, lowResURL: String) {
        imageLoader.load(regularURL, lowResPath: lowResURL)
    }
    
    func cleanAndReuse() {
//        cancellable?.cancel()
        imageView.image = nil
    }
}
