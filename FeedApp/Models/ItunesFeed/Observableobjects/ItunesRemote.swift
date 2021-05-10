//
//  ItunesRemote.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine

protocol ItunesFetchMediaType: AnyObject {
    func fetch(_ mediaType: MediaType)
}

enum ItuneGroup: String, CaseIterable {
    
    case apps = "Apps From the Appstore"
    case books = "Books From Itunes"
    case podcats = "Pdocasts"
    case tvShows = "TV Shows"
    case movies = "Movies"
    
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
    private var fileLocalManager = FileManagerLocal()
    
    @Published var sectionFeedViewModels: [FeedItemViewModel] = []
    
    @Published var feedError: Error?
    @Published var groups: [GenericSectionIdentifierViewModel<ItuneGroup, FeedItemViewModel>] = []
    
    @Published var artists: [ArtistViewModel] = []
    
    func getAppGroups(_ groups: [ItuneGroup]) {
        
        if #available(iOS 14.0, *) {
            groups.map { service.fetch(Feed<ItunesResources<FeedItem>>.self, itunes: Itunes(mediaTypePath: $0.mediaType)).eraseToAnyPublisher() }
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
    
    func searchWithTerm(_ term: String) {
        cancellable = service.searcForArtistWithTerm(ItunesSearchResult<Artist>.self, term).sink(receiveCompletion: { value in
            dump(value)
        }, receiveValue: { [weak self] resource in
            guard let self = self else { return }
            self.artists = resource.results.map { ArtistViewModel(artist: $0) }
        })
    }
}

extension ItunesRemote: ItunesFetchMediaType {
    
    private func loadItemsFeedFromCache() {
        if let data = fileLocalManager.cachedEvent() {
            do {
                let unarchivedDate = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data
                let feeditems = try PropertyListDecoder().decode([FeedItem].self, from: unarchivedDate)
                self.sectionFeedViewModels = feeditems.compactMap { FeedItemViewModel(model: $0) }
            } catch {
                print("this is in file manager \(error)")
                return
            }
        }
    }
    
    func fetch(_ mediaType: MediaType) {
        let itunes = Itunes(mediaTypePath: mediaType)
        let path = "\(itunes.request.url?.absoluteString ?? "")"
        print("PATH: \(path)")

        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, itunes: itunes).sink(receiveCompletion: { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .failure(error):
                /// load from cache
                self.loadItemsFeedFromCache()
                
               // self.feedError = error
                print("this is error \(error)")
            case .finished:
                print("this is done")
            }
        },
        receiveValue: { [weak self] resource in
            guard let self = self else { return }
            guard let feed = resource.feed else { return }
            self.sectionFeedViewModels = feed.results.compactMap { FeedItemViewModel(model: $0) }
            
            guard let feedCacheDirectory = self.fileLocalManager.eventLocalFilePath() else {
                print("Some worng with feedCacheDirectory")
                return
            }
            let data = try! PropertyListEncoder().encode(feed.results)
            let m = try! NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try! m.write(to: feedCacheDirectory)
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

class FileManagerLocal {
    
    func eventLocalFilePath() -> URL? {
        guard
//            let hash = ComponentBridge.hasher?.md5Hash(of: urlString),
            let systemCachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        var eventFolder = systemCachesDirectory.appendingPathComponent("Events", isDirectory: true)
        guard FileManager.default.fileExists(atPath: eventFolder.absoluteString) else {
            do {
                try FileManager.default.createDirectory(at: eventFolder, withIntermediateDirectories: true, attributes: nil)
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try eventFolder.setResourceValues(resourceValues)
            } catch {
                return nil
            }
            let eventFilePath = eventFolder.appendingPathComponent("event").appendingPathExtension("txt")
            return eventFilePath
        }
        let eventFilePath = eventFolder.appendingPathComponent("event").appendingPathExtension("txt")
        return eventFilePath
    }
    
    func cachedEvent() -> Data? {
        guard let eventLocalPath = eventLocalFilePath() else { return nil }
        do {
            return try Data(contentsOf: eventLocalPath)
        } catch {
            return nil
        }
    }
}
