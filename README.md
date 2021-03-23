# SimpleFeedApp 🤷🏽‍♂️
[![ForTheBadge built-with-love](http://ForTheBadge.com/images/badges/built-with-love.svg)](https://GitHub.com/Naereen/)

SimpleFeed App is a simple app that uses the RSS Feed Itunes Generator API and Marvel API to display feeds with layouts that adapts to iPad and iPhone, taking advantage of generics, protocols, meta types and enums to create reusable components. 

Its main purpose is to build a project using some concepts from my personal 
[blog posts](https://jamesrochabrun.medium.com) where I will like to highlight:

- [Using Generics and Protocols to create Reusable UI](#Using-Generics-and-Protocols-to-create-Reusable-UI)
- [Using Generics and Protocols to create Reusable Networking layers](#Using-Generics-and-Protocols-to-create-Reusable-Networking-layers)
- [Adapting your App for iPad and iPhone](#Adapting-your-App-for-iPad-and-iPhone)

# Requirements

* iOS 13.0 or later

# Features

- [X] Supports Dynamic layout for iPad and iPhone.
- [X] Supports adapting UI to any kind of custom layout.
- [X] Uses 
[MarvelClient](https://github.com/jamesrochabrun/MarvelClient) a personal Swift Package that fetches data from Marvel API.
- [X] Fetches data from [RSS Feed Generator](https://rss.itunes.apple.com/en-us/?country=ca) API's.
- [X] Supports Dark mode.

# Technologies

- Swift
- Combine
- Diffable Data Source
- Compositional Layout 

# Architechture

- MVVM and Combine.

# Highlights

## Using Generics and Protocols to create Reusable UI

The app Uses a Tab bar controller as main root, each of its tabs display a certain feed that follows the same pattern:

1 - Create a Section Model, this object will represent a section in a collectionView. It must conform to `SectionIdentifierViewModel` e.g:

```swift
typealias HomeFeedSectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>
/// `GenericSectionIdentifierViewModel` is a generic object that avoids the creaton of a different class for every feed, it conforms to `SectionIdentifierViewModel`
```

2 - Sub Class `GenericFeedViewController` to create a view controller feed, the class looks like this:

```swift
class GenericFeedViewController<Content: SectionIdentifierViewModel, Remote: RemoteObservableObject>: ViewController {
}
```
It has two generic constraints:

```Swift
/// 1 `SectionIdentifierViewModel` Represents a the declaration in a feed, it looks like this...

protocol SectionIdentifierViewModel: AnyObject {
    
    associatedtype SectionIdentifier: Hashable <- A Section in a collection view
    associatedtype CellIdentifier: Hashable <- The object that will be displayed in a section
    associatedtype CellType: ViewModelCellInjection <- A PAT that allows a cell be injected by a view model.
    
    var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
    var cellIdentifierType: CellType.Type { get } 
}

/// Note: By now we only support one type of cell for a collection view.
/// Note2: By now we can use any kind of reusable view as header or footer.
```

```swift 
/// 2 `RemoteObservableObject` an object that conforms to `ObservableObject` and is responsible for fetching data, it looks like this...
protocol RemoteObservableObject : ObservableObject {
    init()
}
/// This allows to encapsulate the instantiation of a certain remote object inside a generic class.
```

By using this two generic constraints we define the dependencies needed for a feed but also it let us create any kind of feed, lets see it in practice, this is how the home feed in the app looks like, less than 55 lines of code.

```swift
/// A
enum HomeFeedSectionIdentifier: String, CaseIterable {
    case popular = "Popular"
}

/// B
typealias HomeFeedSectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel, ArtworkCell>

/// C
final class HomeViewController: GenericFeedViewController<HomeFeedSectionModel, ItunesRemote> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
    /// D
        remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
    /// E
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
            /// F
                collectionView.registerHeader(StoriesSnippetWithAvatarCollectionReusableView.self, kind: kind)
                let header: StoriesSnippetWithAvatarCollectionReusableView = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
                header.viewModel = model
                header.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return header
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return UICollectionReusableView()
            }
        }
    }
    
    override func updateUI() {
        /// G
        remote.$sectionFeedViewModels.sink { [weak self] in
            let homeFeedSectionItems = [HomeFeedSectionModel(sectionIdentifier: .popular, cellIdentifiers: $0)]
            self?.collectionView.applyInitialSnapshotWith(homeFeedSectionItems)
        }.store(in: &cancellables)
    }
}
```

- A) Define the section identifier for a Diffable DataSource, it can be anything as long it conforms to `Hashable`
- B) Define the Home section model, in this case `GenericSectionIdentifierViewModel` defines a <SectionIdentifier, CellIdentifier, CellType>
- C) Subclass `GenericFeedViewController` and define the constraints, here it will use `HomeFeedSectionModel` as a section model, and the `ItunesRemote` object to fetch itunes feed data.
- D) Call the remote fetch request, `ItunesRemote` uses the `ItunesClient` class that uses generics, protocols and meta types to avoid code duplication.
- E) Here we define the headers, footers for the collection view, this must be defined in the layout level, means that we need to provide this implementation if our layout is defined to use headers or footers.
- F) Use the section identifier to switch and provide a certain header or footer for a section.
- G) Use the `Publisher` to update your UI.

For more about generic UI you can go to:

- [Advanced Generics to create reusable UI](https://jamesrochabrun.medium.com/advance-generics-to-create-reusable-ui-f0b8b8934895)
- [Using Generic code in UIKit to construct a compositional List in SwiftUI](https://jamesrochabrun.medium.com/compositional-swiftui-list-266bff7844af)

## Using Generics and Protocols to create Reusable Networking layers

Itunes Client uses `CombineAPI` its architechture uses `Combine` to perform networking requests and publish changes.
The Itunes RSS feed loads from apps, to movies and we can fetch any kind of data by using generic code like this...

```swift
public struct Author: Decodable {
    let name: String
    let uri: String
}

public protocol ItunesResource: Decodable {
    associatedtype Model
    var title: String? { get }
    var id: String? { get }
    var author: Author? { get }
    var copyright: String? { get }
    var country: String? { get }
    var icon: String? { get }
    var updated: String? { get }
    var results: [Model]? { get }
}

public struct ItunesResources<Model: Decodable>: ItunesResource {
    
    public let title: String?
    public let id: String?
    public let author: Author?
    public let copyright: String?
    public let country: String?
    public let icon: String?
    public let updated: String?
    public let results: [Model]?
}

public protocol FeedProtocol: Decodable {
    associatedtype FeedResource: ItunesResource
    var feed: FeedResource? { get }
}

public struct Feed<FeedResource: ItunesResource>: FeedProtocol {
    public let feed: FeedResource?
}
```

We can also model the paths for a certain request using enums, like this...

```swift
enum MediaType {
    
    case appleMusic(feedType: AppleMusicFeedType, limit: Int)
    case itunesMusic(feedType: ItunesMusicFeedType, limit: Int)
    case apps(feedType: AppsFeedType, limit: Int)
    case audioBooks(feedType: AudioBooksFeedType, limit: Int)
    case books(feedType: BooksFeedType, limit: Int)
    case tvShows(feedType: TVShowFeedType, limit: Int)
    case movies(feedType: MovieFeedType, limit: Int)
    case podcast(feedType: PodcastFeedType, limit: Int)
    case musicVideos(feedType: MusicVideoFeedType, limit: Int)
    
    var path: String {
        switch self {
        case .appleMusic(let feedType, let limit): return "/apple-music/\(feedType.path)/\(limit)/explicit.json"
        case .itunesMusic(let feedType, let limit): return "/itunes-music/\(feedType.path)/\(limit)/explicit.json"
        case .apps(let feedType, let limit): return "/ios-apps/\(feedType.path)/\(limit)/explicit.json"
        case .audioBooks(let feedType, let limit): return "/audiobooks/\(feedType.path)/\(limit)/explicit.json"
        case .books(let feedType, let limit): return "/books/\(feedType.path)/\(limit)/explicit.json"
        case .tvShows(let feedType, let limit): return "/tv-shows/\(feedType.path)/\(limit)/explicit.json"
        case .movies(let feedType, let limit): return "/movies/\(feedType.path)/\(limit)/explicit.json"
        case .podcast(let feedType, let limit): return "/podcasts/\(feedType.path)/\(limit)/explicit.json"
        case .musicVideos(let feedType, let limit): return "/music-videos/\(feedType.path)/\(limit)/explicit.json"
        }
    }
}
.....more.....
```

The method to perform a request will look as simple as this...

```swift
  func fetch(_ mediaType: MediaType) {
        cancellable = service.fetch(Feed<ItunesResources<FeedItem>>.self, mediaType: mediaType).sink(receiveCompletion: { value in
        }, receiveValue: { [weak self] resource in
        /// the resource...
         })
    }
```

But even better it will look very descriptive at the moment of consumption...

```swift
remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
/// you can read this and understand what you are requesting.
```

For more of generic networking you can go...

- [Generic Networking layer using Combine in SwiftUI](https://medium.com/if-let-swift-programming/generic-networking-layer-using-combine-in-swift-ui-d23574c20368)
- [Advanced Generics and protocols in Swift](https://blog.usejournal.com/advanced-generics-and-protocols-in-swift-c30020fd5ded) <- Explains how to model decodable objects to avoid code duplication.


## Adapting your App for iPad and iPhone

This app also contains layout implementations that supports iPad and iPhone on different contexts including iPad multitasking, the result looks like this...


- The app on iPad.

![lowDemo1](https://user-images.githubusercontent.com/5378604/112098441-07908d80-8b5f-11eb-8f3e-080e688d2e80.gif)

- Navigation to a selected feed item, on expanded mode.

![scrollToItemExpanded](https://user-images.githubusercontent.com/5378604/112098545-373f9580-8b5f-11eb-8be9-9f78cf17b385.gif)

- Navigation to a selected feed item, on collapsed mode.

![scrollToItemCollapsed](https://user-images.githubusercontent.com/5378604/112098693-6e15ab80-8b5f-11eb-8397-fced2dc3c589.gif)

- Adaptive your layout to split view controller display mode changes.

![adaptiveLayoutDisplayMode](https://user-images.githubusercontent.com/5378604/112098815-a61cee80-8b5f-11eb-840e-9447b6c3ea4b.gif)

- Adapt your layout on trait collection changes 

![adaptiveLayouttraits](https://user-images.githubusercontent.com/5378604/112098956-dc5a6e00-8b5f-11eb-9ab9-773925b0a13e.gif)

- Adapt your layout on device orientation

![AdaptiveLayoutorientation](https://user-images.githubusercontent.com/5378604/112106963-97d4cf80-8b6b-11eb-84c2-5dd277f0a5b1.gif)

- The app in iPhone

![iPhoneLayout](https://user-images.githubusercontent.com/5378604/112099309-80dcb000-8b60-11eb-856e-c4706d054585.gif)

- Dark/Light Mode

![darkMode](https://user-images.githubusercontent.com/5378604/112099404-aff32180-8b60-11eb-929c-17a9234b4c1f.gif)

More on Building for iPad you can go:

- [Building iPad apps, prototyping Instagram for iPad](https://medium.com/dev-genius/building-ipad-apps-prototyping-instagram-for-ipad-part-one-9ce4d03ec18a)
- [Sidebar in iPad iOS 14, explained.](https://medium.com/dev-genius/sidebar-in-ipad-ios-14-explained-2617ffef09fa)
