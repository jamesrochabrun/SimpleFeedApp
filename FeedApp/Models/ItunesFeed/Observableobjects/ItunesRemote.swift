//
//  ItunesRemote.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine

enum ItuneGroup: CaseIterable {
    case apps
    case books
    case podcats
    case tvShows
    case movies
    
    var mediaType: MediaType {
        switch self {
        case .apps: return .apps(feedType: .topFree(genre: .all), limit: 10)
        case .books: return .books(feedType: .topFree(genre: .all), limit: 10)
        case .podcats: return .podcast(feedType: .top(genre: .all), limit: 10)
        case .tvShows: return .tvShows(feedType: .topTVEpisodes(genre: .all), limit: 10)
        case .movies: return .movies(feedType: .top(genre: .all), limit: 10)
        }
    }
}

final class ItunesRemote: ObservableObject {

    private let service = ItunesClient()
    private var cancellable: AnyCancellable?
    
    private var cancellables: Set<AnyCancellable> = []

    @Published var sectionFeedViewModels: [FeedItemViewModel] = []
    
    @Published var groups: [GenericSectionIdentifierViewModel<ItuneGroup, FeedItemViewModel>] = []

    @Published var artists: [ArtistViewModel] = []
    
    func getAppGroups(_ groups: [ItuneGroup]) {
        
        if #available(iOS 14.0, *) {
            groups.map { service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: $0.mediaType).eraseToAnyPublisher() }
                .publisher
                .flatMap { $0 }
                .collect()
                .sink {
                    dump($0)
                } receiveValue: { groups in
                    /// TODO: Fix order why the array is not in order?
                    var finalGroups: [GenericSectionIdentifierViewModel<ItuneGroup, FeedItemViewModel>] = []
                    for i in 0..<groups.count {
                        let sectionIdentifier = ItuneGroup.allCases[i]
                        // TODO: optimize this nested loop currently O notation is (groups * results)
                        let cellIdentifiers = groups[i].feed?.results.compactMap { FeedItemViewModel(model: $0) } ?? []
                        let section = GenericSectionIdentifierViewModel(sectionIdentifier: sectionIdentifier, cellIdentifiers: cellIdentifiers)
                        finalGroups.append(section)
                    }
                    self.groups = finalGroups
                }.store(in: &cancellables)
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    

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
