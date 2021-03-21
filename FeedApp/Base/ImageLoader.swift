//
//  ImageLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit
import Combine

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
        
    // MARK:- Private Properties
    private let imageCache = ImageCache.shared
    
    // MARK:- Private methods.
    func load(_ path: String, lowResPath: String) {
        guard !loadImageFromCache(path) else { return }

        guard let url = URL(string: path) else { return }
        guard let urlLowRes = URL(string: lowResPath) else { return }

        loadImageFromURL(url, lowResURL: urlLowRes)
    }
    
    private func loadImageFromCache(_ path: String) -> Bool {
        guard let cacheImage = imageCache.imageForKey(path) else { return false }
        image = cacheImage
        return true
    }
    
    
    private func loadImageFromURL(_ url: URL, lowResURL: URL) {
        adaptiveLoader(regularURL: url, lowDataURL: lowResURL)
            .tryMap { data in
                let image = UIImage(data: data)!
                self.imageCache.setImageForKey(url.absoluteString, image: image)
                return image
            }
            .retry(2)
            .replaceError(with: UIImage(systemName: "photo"))
            .receive(on: DispatchQueue.main)
            .assign(to: &$image)
    }
    
    func adaptiveLoader(regularURL: URL, lowDataURL: URL) -> AnyPublisher<Data, Error> {
        
        var request = URLRequest(url: regularURL)
        request.allowsConstrainedNetworkAccess = false
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard
                    error.networkUnavailableReason == .constrained else {
                    throw error
                }
                return URLSession.shared.dataTaskPublisher(for: lowDataURL)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.requestFailed(description: "Error Response \(response)")
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}


