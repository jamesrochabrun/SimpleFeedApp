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


public protocol ReusableViewModel: UICollectionReusableView {
//    associatedtype SectionIdentifier
//    var sectionIdentifier: SectionIdentifier? { get set }
}


/// Helper
public struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
                                                ReusableView: ReusableViewModel,
                                                CellIdentifier: Hashable,
                                                Cell: CellViewModel>: SectionIdentifierViewModel {
    
    public var sectionIdentifier: SectionIdentifier? = nil
    public var sectionIdentifierReusableViewType: ReusableView.Type

    public var cellIdentifiers: [CellIdentifier]
    public var cellIdentifierType: Cell.Type
}

// Step 1: create a section identifier
public enum SectionIdentifierExample: String, CaseIterable {
    
    
    case popular = "Popular"
    case new = "New"
//    case top = "Top Items"
//    case recent = "Recent"
//    case comingSoon = "Coming Soon"
}

//final class ItunesRemoteModels: ObservableObject {
//
//    private let service = ItunesClient()
//    private var cancellable: AnyCancellable?
//    @Published var models: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, FeedItemViewModel, ArtworkCell>] = []
//
//
//    func fetchItems(_ mediaType: MediaType) {
//        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: {
//            dump($0)
//        }, receiveValue: { feed in
//            let chunkCount = feed.feed?.results?.count ?? 1 / SectionIdentifierExample.allCases.count
//            let chunks = feed.feed?.results?.compactMap { FeedItemViewModel(model: $0) }.chunked(into: chunkCount) ?? []
//            var sectionIdentifiers: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, FeedItemViewModel, ArtworkCell>] = []
//            for i in 0..<SectionIdentifierExample.allCases.count {
//                sectionIdentifiers.append(GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.allCases[i], sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: chunks[i], cellIdentifierType: ArtworkCell.self))
//            }
//            self.models = sectionIdentifiers
//         })
//    }
//}

//final class ItunesRemote: ObservableObject {
//
//    private let service = ItunesClient()
//    private var cancellable: AnyCancellable?
//
//    @Published var feedItems: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, FeedItemViewModel, ArtworkCell>] = []
//
//    func fetchItems(_ mediaType: MediaType) {
//        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: { value in
//            dump(value)
//        }, receiveValue: { feed in
//            let chunkCount = feed.feed?.results?.count ?? 1 / SectionIdentifierExample.allCases.count
//            guard let chunks = feed.feed?.results?.compactMap({ FeedItemViewModel(model: $0) }).chunked(into: chunkCount) else { return }
//            var sectionIdentifiers: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, FeedItemViewModel, ArtworkCell>] = []
//            for i in 0..<SectionIdentifierExample.allCases.count {
//                sectionIdentifiers.append(GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.allCases[i], sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: chunks[i], cellIdentifierType: ArtworkCell.self))
//            }
//            self.feedItems = sectionIdentifiers
//         })
//    }
//}

// Helper, currently Itunes RSS feed does not return sectioned data, in order to
// show how compositional list works with sections we chunked the available data from the Itunes API.
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//public enum ContentSectionIdentifier {
//    case characters
//    case series
//}
//
//public enum ContentCellIdentifier {
//
//    case first(GenericSectionIdentifierViewModel<SectionIdentifierExample, CharacterViewModel, ArtworkCell>)
//    case second(GenericSectionIdentifierViewModel<SectionIdentifierExample, CharacterViewModel, ArtworkCell>)
//}

final class MarvelProvider: ObservableObject {

    private let service = MarvelService(privateKey: "6905a8e2fb2033fdb10eea66645116669f1c4f04", publicKey: "27d25dbafd3ff80a9d448a19c11ace4d")
    
    @Published var series: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, SerieViewModel, ArtworkCell>] = []
    @Published var characters: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, CharacterViewModel, ArtworkCell>] = []
    @Published var comics: [GenericSectionIdentifierViewModel<SectionIdentifierExample, CollectionReusableView, ComicViewModel, ArtworkCell>] = []
        
    func fetchSeries() {
        service.fetch(MarvelData<Resources<Serie>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { SerieViewModel(model: $0) }
                let vms = [GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.new, sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self)]
                self.series = vms
            case .failure: break
            }
        }
    }

    func fetchCharacters() {
        service.fetch(MarvelData<Resources<Character>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { CharacterViewModel(model: $0) }
                let vms = [GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.popular, sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self)]
                self.characters = vms//SectionIdentifierExample.allCases.map { GenericSectionIdentifierViewModel(sectionIdentifier: $0, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self) }
            case .failure: break
            }
        }
    }

    func fetchComics(for section: SectionIdentifierExample) {
        service.fetch(MarvelData<Resources<Comic>>.self) { resource in
            switch resource {
            case .success(let results):
                let cellIdentifiers = results.map { ComicViewModel(model: $0) }
                let vms = [GenericSectionIdentifierViewModel(sectionIdentifier: section, sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self)]
                self.comics = vms
//                self.comics = SectionIdentifierExample.allCases.map { GenericSectionIdentifierViewModel(sectionIdentifier: $0, cellIdentifiers: cellIdentifiers, cellIdentifierType: ArtworkCell.self) }

                return
                
                let chunkCount = cellIdentifiers.count / SectionIdentifierExample.allCases.count
                let chunks = cellIdentifiers.chunked(into: chunkCount)
                
                if section == .popular {
                let vms = [GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.popular, sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: chunks.first ?? [], cellIdentifierType: ArtworkCell.self)]
                    self.comics = vms
                } else {
                    let vms = [GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.new, sectionIdentifierReusableViewType: CollectionReusableView.self, cellIdentifiers: chunks.last ?? [], cellIdentifierType: ArtworkCell.self)]
                        self.comics = vms
                }
//
//                var sectionIdentifiers: [GenericSectionIdentifierViewModel<SectionIdentifierExample, ComicViewModel, ArtworkCell>] = []
//                for i in 0..<SectionIdentifierExample.allCases.count {
//                    sectionIdentifiers.append(GenericSectionIdentifierViewModel(sectionIdentifier: SectionIdentifierExample.allCases[i], cellIdentifiers: chunks[i], cellIdentifierType: ArtworkCell.self))
//                }
//                self.comics = sectionIdentifiers
                
            case let .failure(err): print("the error is \(err)")
            }
        }
    }
}
