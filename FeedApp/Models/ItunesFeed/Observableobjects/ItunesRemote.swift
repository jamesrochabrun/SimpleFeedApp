//
//  ItunesRemote.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine

final class ItunesRemote: ObservableObject {

    private let service = ItunesClient()
    private var cancellable: AnyCancellable?

    @Published var sectionFeedViewModels: [FeedItemViewModel] = []
    @Published var artists: [ArtistViewModel] = []

    func fetch(_ mediaType: MediaType) {
        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: { value in
        }, receiveValue: { [weak self] resource in
            guard let self = self else { return }
            self.sectionFeedViewModels = resource.feed?.results.compactMap { FeedItemViewModel(model: $0) } ?? []
         })
    }
    
    func searchWithTerm(_ term: String) {
        cancellable = service.searcForArtistWithTerm(ItunesSearchResult<Artist>.self, term).sink(receiveCompletion: { value in
            dump(value)
        }, receiveValue: { [weak self] resource in
            guard let self = self else { return }
            self.artists = resource.results.map { ArtistViewModel(artist: $0) }
        })
    }
}

// Helper, currently Itunes RSS feed does not return sectioned data, in order to
// show how compositional list works with sections we chunked the available data from the Itunes API.
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
