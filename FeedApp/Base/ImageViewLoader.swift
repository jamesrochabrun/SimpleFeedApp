//
//  ImageViewLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import Combine

final class ImageViewLoader: BaseView {
    
    private lazy var imageLoader: ImageLoader = {
        ImageLoader()
    }()
    private var cancellables: Set<AnyCancellable> = []

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    func load(regularURL: String, lowResURL: String) {
        imageLoader.load(regularURL, lowResPath: lowResURL)
         imageLoader.$image.sink { [unowned self] image in
             imageView.image = image
            dump(image)
         }.store(in: &cancellables)
    }
}
