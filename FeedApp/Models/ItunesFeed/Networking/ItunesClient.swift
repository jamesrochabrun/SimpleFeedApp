//
//  ItunesClient.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Combine
import Foundation


final class ItunesClient: CombineAPI {
    
    // 1
    let session: URLSession
    
    var cancellables: Set<AnyCancellable> = []
    // 2
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // 3
    public func fetch<Feed: FeedProtocol>(_ feed: Feed.Type,
                                          itunes: Itunes) -> AnyPublisher<Feed, Error> {
        print("PATH: \(String(describing: itunes.request.url?.absoluteString))")
        return execute(itunes.request, decodingType: feed)
    }
    
    /// itunes Search
    public func searcForArtistWithTerm<Result: Decodable>(_ type: Result.Type, _ term: String) -> AnyPublisher<Result, Error> {
        let ituneSearch = ItunesSearch.search(term: term, media: .music(entity: .musicArtist, attribute: .artistTerm))
        print("PATH: \(String(describing: ituneSearch.request.url?.absoluteString))")
        return execute(ituneSearch.request, decodingType: type)
    }
}
