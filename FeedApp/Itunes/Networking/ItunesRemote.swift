//
//  ItunesRemote.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine
import SwiftUI
import MarvelClient


/// Helper
public struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
                                                CellIdentifier: Hashable,
                                                CellType: CellViewModel>: SectionIdentifierViewModel {
    
    public var sectionIdentifier: SectionIdentifier? = nil
    public var cellIdentifiers: [CellIdentifier]
    public var cellIdentifierType: CellType.Type
}



// Step 1: create a section identifier
public enum SectionIdentifierExample: String, CaseIterable {
    
    
    case popular = "Popular"
//    case new = "New"
//    case top = "Top Items"
//    case recent = "Recent"
//    case comingSoon = "Coming Soon"
    
}

final class ItunesRemoteModels: ObservableObject {

    private let service = ItunesClient()
    private var cancellable: AnyCancellable?
    @Published var models: [GenericSectionIdentifierViewModel<SectionIdentifierExample, FeedItemViewModel, ArtworkCell>] = []
    
    
    func fetchItems(_ mediaType: MediaType) {
        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: {
            dump($0)
        }, receiveValue: { feed in
            let chunkCount = feed.feed?.results?.count ?? 1 / SectionIdentifierExample.allCases.count
            let chunks = feed.feed?.results?.compactMap { FeedItemViewModel(model: $0) }.chunked(into: chunkCount) ?? []
            var sectionIdentifiers: [GenericSectionIdentifierViewModel<SectionIdentifierExample, FeedItemViewModel, ArtworkCell>] = []
            for i in 0..<SectionIdentifierExample.allCases.count {
                sectionIdentifiers.append(GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.allCases[i], cellIdentifiers: chunks[i], cellIdentifierType: ArtworkCell.self))
            }
            self.models = sectionIdentifiers
         })
    }
}

final class ItunesRemote: ObservableObject {

    private let service = ItunesClient()
    private var cancellable: AnyCancellable?

    @Published var feedItems: [GenericSectionIdentifierViewModel<SectionIdentifierExample, FeedItemViewModel, ArtworkCell>] = []
        
    func fetchItems(_ mediaType: MediaType) {
        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: { value in
            dump(value)
        }, receiveValue: { feed in
            let chunkCount = feed.feed?.results?.count ?? 1 / SectionIdentifierExample.allCases.count
            guard let chunks = feed.feed?.results?.compactMap({ FeedItemViewModel(model: $0) }).chunked(into: chunkCount) else { return }
            var sectionIdentifiers: [GenericSectionIdentifierViewModel<SectionIdentifierExample, FeedItemViewModel, ArtworkCell>] = []
            for i in 0..<SectionIdentifierExample.allCases.count {
                sectionIdentifiers.append(GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.allCases[i], cellIdentifiers: chunks[i], cellIdentifierType: ArtworkCell.self))
            }
            self.feedItems = sectionIdentifiers
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


final class MarvelProvider: ObservableObject {

    private let service = MarvelService(privateKey: "6905a8e2fb2033fdb10eea66645116669f1c4f04", publicKey: "27d25dbafd3ff80a9d448a19c11ace4d")
    
    @Published var series: [GenericSectionIdentifierViewModel<SectionIdentifierExample, SerieViewModel, ArtworkCell>] = []
    @Published var characters: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CharacterViewModel, ArtworkCell>] = []
    @Published var comics: [GenericSectionIdentifierViewModel<SectionIdentifierExample, ComicViewModel, ArtworkCell>] = []
        
    func fetchSeries() {
        service.fetch(MarvelData<Resources<Serie>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { SerieViewModel(model: $0) }
                self.series = SectionIdentifierExample.allCases.map { GenericSectionIdentifierViewModel(sectionIdentifier: $0, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self) }
            case .failure: break
            }
        }
    }

    func fetchCharacters() {
        service.fetch(MarvelData<Resources<Character>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { CharacterViewModel(model: $0) }
                self.characters = SectionIdentifierExample.allCases.map { GenericSectionIdentifierViewModel(sectionIdentifier: $0, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self) }
            case .failure: break
            }
        }
    }

    func fetchComics() {
        service.fetch(MarvelData<Resources<Comic>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { ComicViewModel(model: $0) }
                self.comics = SectionIdentifierExample.allCases.map { GenericSectionIdentifierViewModel(sectionIdentifier: $0, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self) }
            case .failure: break
            }
        }
    }
}
