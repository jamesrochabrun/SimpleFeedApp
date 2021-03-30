//
//  TabBarController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit

// MARK:- TabBarController
final class TabBarController: UITabBarController {
    /// 1 - Set view Controllers using `TabBarViewModel`
       /// 2 - This iteration will create a master veiw controller embedded in a navigation controller for each tab.
       /// 3 - `inSplitViewControllerIfSupported` is a `UINavigationController` extension method that will embed it in a `UISplitViewController` if supported.
       /// we will see the implementation later.
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabBarViewModel.allCases.map { NavigationController(rootViewController: $0.masterViewController).inSplitViewControllerIfSupported(for: $0) }
    }
}

// MARK:- ViewModel
enum TabBarViewModel: String, CaseIterable {
    
    case home
    case discover
    case profile
    case marvel
    
    /// Return:- the tab bar icon
    var icon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house.fill")
        case .discover: return UIImage(systemName: "magnifyingglass")
        case .profile: return UIImage(systemName: "person")
        case .marvel: return UIImage(systemName: "magnifyingglass")
        }
    }
    /// Return:- the tab bar title
    var title: String { rawValue }
    
    /// Return:-  the master/primary `topViewController`,  it instantiates a view controller using a convenient method for `UIStoryboards`.
    var masterViewController: UIViewController  {
        switch self {
        case .home:
            return HomeViewController(layout: layout)
        case .discover:
            return DiscoverViewController(layout: layout)
        case .profile:
            return UserProfileViewController(layout: layout)
        case .marvel:
            return MarvelFeedViewController(layout: layout)
        }
    }
    
    var layout: UICollectionViewLayout {
        switch self {
        case .home, .marvel: return UICollectionViewCompositionalLayout.homeLayout()
        case .discover: return UICollectionViewCompositionalLayout.discoverLayout()
        case .profile: return UICollectionViewCompositionalLayout.gridProfileLayout(3)
        }
    }
    
    /// - Return:-  It defines if a tab should use a `UISplitViewController` as root or not.
    var inSplitViewController: Bool {
        switch self {
        case .profile: return true
        default: return false
        }
    }
}

extension UINavigationController {
    /**
     - parameters:
       - viewModel: The `TabBarViewModel` element.
    */
    func inSplitViewControllerIfSupported(for viewModel: TabBarViewModel) -> UIViewController {
        
        /// Use this if a certain tab needs a split view, here you can also introduce A/B testing if display a feed as a split or full width of screen.
        guard viewModel.inSplitViewController else {
            self.tabBarItem.image = viewModel.icon
            return self
        }
        let splitViewController = SplitViewController(viewControllers: [self, EmptyDetailViewController()])
        splitViewController.tabBarItem.image = viewModel.icon
        return splitViewController
    }
}



import MarvelClient

///  Step 1 - define a section identifier
enum Marvel {
    case one
}


class MarvelFeedViewController: GenericFeedViewController<MarvelFeedViewController.MarvelFeed, MarvelRemote>  {
    
    // step 2 - Define a model for a section model
    typealias MarvelFeed = GenericSectionIdentifierViewModel<Marvel, ComicViewModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // step 3 - fetch the objects
        remote.fetchComics()
        
        /// step 4 configure the cells
        collectionView?.cellProvider { collectionView, indexPath, model in
            let cell: ArtworkCell = collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath)
            return cell
        }
        
        
        /// step 5 perform the update
        remote.$comicViewModels.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView?.content {
                MarvelFeed(sectionIdentifier: .one, cellIdentifiers: models)
            }
        }.store(in: &cancellables)
        
        // step 6
        /// optional configutre a supplementary view.
    }
}
