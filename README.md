# SimpleFeedApp 🤓
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
- [X] Supports insert/delete of sections and cell identifiers.

# Technologies

- Swift
- Combine
- Diffable Data Source
- Compositional Layout 
- Swift Package.
- (Disclaimer, this project uses SDWebImage framework for loading images, it was used for convenience and because the project is not intended to showcase best way to load images. 🤷🏽‍♂️

# Architechture

- MVVM and Combine.

# Highlights

## Using Generics and Protocols to create Reusable UI

The app displays a feed of items from the RSS itunes API and uses the Marvel API to display content in headers.
The app Uses a Tab bar controller as main root, each of its tabs display a view controller sub class of `GenericFeedViewController` the super class definition looks like this:

```swift
class GenericFeedViewController<Content: SectionIdentifierViewModel, Remote: RemoteObservableObject>: ViewController {
}
```

- This class inherits from `ViewController` which is in charge of the theming of the app.
- This view controller contains a `DiffableCollectionView<SectionContentViewModel: SectionIdentifierViewModel>` view, which is the one that displays the items in a collectionview.
- This class has two generic constraints, `RemoteObservableObject` which is an object that conforms to `ObservableObject` and its in charge of providing the updated content, and `SectionIdentifierViewModel` which is in charge of displaying the content.

`SectionIdentifierViewModel` is a PAT that represents the structure of a section in a collectionview its definition looks like this...

```Swift
protocol SectionIdentifierViewModel {
    
    associatedtype SectionIdentifier: Hashable <- A section in a diffable Collection view.
    associatedtype CellIdentifier: Hashable <- A model in a section.
    
    var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
}
``` 

`RemoteObservableObject` is a protocol that inherits from `ObservableObject` its definition looks like this...

```swift
protocol RemoteObservableObject : ObservableObject {
    init()
}
```

## Crating a feed

For Example, for the home feed view controller we will display a feed of items using the itunes music endpoint...

1 - Create an instance that inherits from `GenericFeedViewController` and declare the types for the two generic constraints.

```swift
/// A
// MARK:- Home Feed Diffable Section Identifier
enum HomeFeedSectionIdentifier {
    case popular
    case adds
}

/// C
final class HomeViewController: GenericFeedViewController<HomeViewController.SectionModel, ItunesRemote> {
    
    // MARK:- Section ViewModel
    /// - Typealias that describes the structure of a section in the Home feed.
    /// B
    typealias SectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel>
...
}
```
- A) Define the section identifier, it can be anything as long it conforms to `Hashable`
- B) Define the types of an object that conforms to `SectionIdentifierViewModel`, we can find a generic object in the repo that conforms to this protocol its definition looks like this...

```swift
struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable, CellIdentifier: Hashable>: SectionIdentifierViewModel {
    /// The Hashable Section identifier in a Diffable CollectionView
    public let sectionIdentifier: SectionIdentifier
    /// The Hashable section items  in a Section in a  Diffable CollectionView
    public var cellIdentifiers: [CellIdentifier]
}
```

You can use it or create your own, the benefit of this approach is that you can reuse this type, it has 2 generic constraints and we need to fill those placeholders, with the types that we want to use, for example, for the `HomeViewController` we want `HomeFeedSectionIdentifier` as a section identifier and a `FeedItemViewModel` as a cell identifier.

- C) Now that we have the type definition for the sections we can use it to define the types for the view controller, here we will use the section we defined in point B and also the `ItunesRemote` which provides different kind of data like apps, apple books, movies, podcasts etc.

With the types defined we can now fetch the object from the remote, configure cells and supplementary views and display the data in the collection view, the full implementation of a simple feed looks like this...

```swift
/// A
enum HomeFeedSectionIdentifier {
    case popular 
}

/// C
final class HomeViewController: GenericFeedViewController<HomeFeedSectionModel.SectionModel, ItunesRemote> {
    
    /// B
    typealias SectionModel = GenericSectionIdentifierViewModel<HomeFeedSectionIdentifier, FeedItemViewModel>

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
    /// D
        remote.fetch(.itunesMusic(feedType: .recentReleases(genre: .all), limit: 100))
    }
    
    override func setUpUI() {
    
        /// E
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
        /// F
        collectionView.assignHedearFooter { collectionView, model, kind, indexPath in
            switch model {
            case .popular:
            /// G
                let reusableView: HomeFeedSupplementaryView = collectionView.dequeueAndConfigureSuplementaryView(with: model, of: kind, at: indexPath)
                reusableView.layout = HorizontalLayoutKind.horizontalStorySnippetLayout.layout
                return reusableView
            default:
                assert(false, "Section identifier \(String(describing: model)) not implemented \(self)")
                return UICollectionReusableView()
            }
        }
    }
    
    override func updateUI() {
        /// H
          remote.$sectionFeedViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
            /// I
                SectionModel(sectionIdentifier: .popular, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
    }
}
```

- A) Define the section identifier for a Diffable DataSource, it can be anything as long it conforms to `Hashable`
- B) Define the type that conforms to `SectionIdentifierViewModel` 
- C) Subclass `GenericFeedViewController` and define the constraints, here it will use `HomeFeedSectionModel.SectionModel` as a section, and the `ItunesRemote` object to fetch itunes feed data.
- D) Call the remote fetch request, `ItunesRemote` uses the `ItunesClient` class that uses generics, protocols and meta types to decode from apps to podcasts.
- E) Here we define the cell, 
- F) Here we define the headers, footers for the collection view, this will work based on the layout definition, if the layout asked for a footer the view returned here will be placed as a footer, to give an example.
- G) Use the section identifier to switch and provide a certain header or footer for a section.
- H) Use the `Publisher` to get the content for updating the UI.
- I) DiffableCollectionView uses a function builder that expects `SectionModel` objects.

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

### TODO
- [] Fix Some layout bugs.
