//
//  ImageViewLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import SDWebImage

final class ImageViewLoader: BaseView, ContentReusable {
    
    private lazy var imageView: PreviewLoaderView = {
        var imageView = PreviewLoaderView(transitionDuration: 0.3)
        return imageView
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    func load(regularURL: String, lowResURL: String, placeholder: UIImage?) {
        self.imageView.alpha = 0
        imageView.loadPreviewWith(thumbnailURL: URL(string: lowResURL), previewImageURL: URL(string: regularURL), placeholder: placeholder) { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.imageView.alpha = 1.0
            }
        }
    }
    
    func cleanAndReuse() {
        imageView.alpha = 1.0
    }
}
