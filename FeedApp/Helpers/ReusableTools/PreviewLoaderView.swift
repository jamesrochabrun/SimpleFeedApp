//
//  PreviewLoaderView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import Foundation
import SDWebImage

/**
  Loads a low res image and waits until the
 */

final class PreviewLoaderView: UIView {
    
    // MARK: Init
    private var transitionDuration: TimeInterval = 0.0
    private var previewLoaded = false
    
    // MARK: - Custom Getters/ Public
    var previewImage: UIImage? {
        get { previewImageView.image }
        set { previewImageView.image = newValue }
    }
    
    
    var placeholderThumbnailImage: UIImage? { placeholderImageView.image }
    
    convenience init(transitionDuration: TimeInterval) {
        self.init(frame: .zero)
        self.transitionDuration = transitionDuration
        self.previewLoaded = false
        setUpViews()
    }
    
    // MARK:- Setup
    private func setUpViews() {
        addSubview(placeholderImageView)
        placeholderImageView.fillSuperview()
        addSubview(previewImageView)
        previewImageView.fillSuperview()
    }
    
    // MARK:- UI
    private let previewImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    
    // MARK:- Private
    private func showImageLoadPlaceholder(_ placeholderUrl: URL?, placeholder: UIImage?) {
        placeholderImageView.sd_setImage(with: placeholderUrl, placeholderImage: placeholder, options: [])
    }
    // MARK:- Public
    func isPreviewLoaded() -> Bool {
        previewLoaded
    }
    /// Loads a Preview without animation.
    func load(previewImageURL: URL?, placeholder: UIImage?, completion: ((Bool) -> Void)?) {
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
   func loadPreviewWith(thumbnailURL: URL?, previewImageURL: URL?, placeholder: UIImage?, completion: ((Bool) -> Void)?) {
        showImageLoadPlaceholder(thumbnailURL, placeholder: placeholder)
        /// Prepare UI for Preview "Display" state.
        func loadImage(isAlreadyCached: Bool) {
            previewImageView.sd_setImage(with: previewImageURL, placeholderImage: placeholder, options: []) { [weak self] previewImage, error, cacheType, url in
                guard let strongSelf = self else { return }
                // Note:- if high res image fail loading keep the thumbnail.
                UIView.animate(withDuration: isAlreadyCached ? 0 : strongSelf.transitionDuration, animations: {
                    strongSelf.previewImageView.alpha = previewImage != nil ? 1.0 : 0
                    strongSelf.placeholderImageView.alpha = previewImage == nil ? 1.0 : 0
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
        /// Check if `preview` has been  cached to display it without animation.
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
