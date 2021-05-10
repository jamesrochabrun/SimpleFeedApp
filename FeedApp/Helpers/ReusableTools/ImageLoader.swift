//
//  ImageLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 5/4/21.
//

import Combine
import UIKit

final class ImageLoader: ObservableObject {
    
    // MARK:- Nested class
    final class ImageCache {
        static let shared = ImageCache()
        private init() {}
        
        private var cache = NSCache<NSString, UIImage>()
        func imageForKey(_ key: String) -> UIImage? {
            cache.object(forKey: NSString(string: key))
        }
        
        func setImageForKey(_ key: String, image: UIImage) {
            cache.setObject(image, forKey: NSString(string: key))
        }
    }
    
    // MARK:- Publisher
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    // MARK:- Private Properties
    private let imageCache = ImageCache.shared
    
    func load(_ url: URL?) {
        guard !loadImageFromCache(url?.absoluteString ?? "") else { return }
        guard let url = url else { return }
        loadImageFromURL(url)
    }
    
    // MARK:- Private methods.
    private func loadImageFromCache(_ path: String) -> Bool {
        guard let cacheImage = imageCache.imageForKey(path) else { return false }
        image = cacheImage
        return true
    }
    
    
    private func loadImageFromURL(_ url: URL) {
        let request = URLRequest(url: url)
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard
                    error.networkUnavailableReason == .constrained else {
                    throw error
                }
                return URLSession.shared.dataTaskPublisher(for: url)
            }
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let image = UIImage(data: $0.data)
                else {
                    throw APIError.responseUnsuccessful(description: $0.response.debugDescription)
                }
                self.imageCache.setImageForKey(url.absoluteString, image: image)
                return image
            }
            .retry(2)
            .replaceError(with: UIImage(systemName: "photo"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
}
