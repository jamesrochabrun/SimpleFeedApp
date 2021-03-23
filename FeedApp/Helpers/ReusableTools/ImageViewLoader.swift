//
//  ImageViewLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import SDWebImage

final class ImageViewLoader: BaseView, ContentReusable {
    
    var imageViewContentMode: UIView.ContentMode  = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageViewContentMode
        }
    }
    
//    private lazy var imageView: PreviewLoaderView = {
//        var imageView = PreviewLoaderView(transitionDuration: 0.3)
//        return imageView
//    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    func load(regularURL: String, lowResURL: String, placeholder: UIImage?) {
        
        imageView.alpha = 0
//        imageView.loadPreviewWith(thumbnailURL: URL(string: lowResURL), previewImageURL: URL(string: regularURL), placeholder: placeholder) { _ in
//                        UIView.animate(withDuration: 0.6, animations: {
//                            self.imageView.alpha = 1.0
//                        })
//
//        }
//        imageView.alpha = 0
        imageView.sd_setImage(with: URL(string: regularURL), placeholderImage: placeholder, options: []) { image, error, cacheType, url in
            guard let image = image else { return }
            self.imageView.image = image
            UIView.animate(withDuration: 0.6, animations: {
                self.imageView.alpha = 1.0
            },
            completion: { _ in
            })
        }
    }
    
    func cleanAndReuse() {
//        imageView.image = nil
//        imageView.alpha = 1
    }
}

@objc public final class PreviewLoaderView: UIView {
    // MARK: Init
    private var transitionDuration: TimeInterval = 0.0
    private var previewLoaded = false
    // MARK: - Custom Getters/ Public
    @objc public var previewImage: UIImage? { previewImageView.image }
    @objc public var placeholderThumbnailImage: UIImage? { placeholderImageView.image }
    @objc public convenience init(transitionDuration: TimeInterval) {
        self.init(frame: .zero)
        self.transitionDuration = transitionDuration
        self.previewLoaded = false
        setUpViews()
    }
    // MARK:- Setup
    func setUpViews() {
        addSubview(placeholderImageView)
        placeholderImageView.fillSuperview()
        addSubview(previewImageView)
        previewImageView.fillSuperview()
    }
    // MARK:- UI
    let previewImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    let placeholderImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    // MARK:- Private
    private func showImageLoadPlaceholder(_ placeholderUrl: URL?, placeholder: UIImage?) {
        placeholderImageView.sd_setImage(with: placeholderUrl, placeholderImage: placeholder, options: [])
    }
    // MARK:- Public
    public func isPreviewLoaded() -> Bool {
        previewLoaded
    }
    /// Loads a Preview without animation.
    @objc public func load(previewImageURL: URL?, placeholder: UIImage?, completion: ((Bool) -> Void)?) {
        previewImageView.sd_setImage(with: previewImageURL, placeholderImage: placeholder, options: []) { [weak self] image, error, cacheType, url in
            guard let _ = image else {
                self?.previewLoaded = false
                completion?(false)
                return
            }
            self?.previewLoaded = true
            completion?(true)
        }
    }
    /// Loads preview with animation and with a `thumbnail` as placeholder.
    @objc public func loadPreviewWith(thumbnailURL: URL?, previewImageURL: URL?, placeholder: UIImage?, completion: ((Bool) -> Void)?) {
        showImageLoadPlaceholder(thumbnailURL, placeholder: placeholder)
        /// Prepare UI for Preview "Display" state.
        func loadImage(isAlreadyCached: Bool) {
            previewImageView.sd_setImage(with: previewImageURL, placeholderImage: placeholder, options: []) { [weak self] previewImage, error, cacheType, url in
                guard let strongSelf = self else { return }
                // Note:- Design request: if high res image fail loading keep the thumbnail. (error state has been requested to design)
                UIView.animate(withDuration: isAlreadyCached ? 0 : strongSelf.transitionDuration, animations: {
                    strongSelf.previewImageView.alpha = previewImage != nil ? 1.0 : 0
                    strongSelf.placeholderImageView.alpha = previewImage != nil ? 1.0 : 0
                }) { [weak self] _ in
                    strongSelf.previewImageView.isHidden = previewImage == nil
                    strongSelf.placeholderImageView.isHidden = previewImage != nil
                    guard let _ = previewImage else {
                        self?.previewLoaded = false
                        completion?(false)
                        return
                    }
                    self?.previewLoaded = true
                    completion?(true)
                }
            }
        }
        /// Check if `preview` has been  chached to display it without animation.
        SDImageCache.shared.containsImage(forKey: SDWebImageManager.shared.cacheKey(for: previewImageURL), cacheType: .all) { [weak self] cacheType in
            let isAlreadyCached = cacheType != .none
            guard let strongSelf = self else { return }
            // Needed to work in a `tableView` or `collectionView` on scrolling.
            strongSelf.previewImageView.alpha = isAlreadyCached ? 1.0 : 0
            strongSelf.previewImageView.isHidden = !isAlreadyCached
            strongSelf.placeholderImageView.alpha = isAlreadyCached ? 0 : 1.0
            strongSelf.placeholderImageView.isHidden = isAlreadyCached
            loadImage(isAlreadyCached: isAlreadyCached)
        }
    }
}
