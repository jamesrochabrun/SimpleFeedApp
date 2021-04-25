//
//  TabBarItemFactory.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/23/21.
//

import UIKit

// MARK:- ViewModel
enum TabBarFactory: String, CaseIterable {
    
    case home
    case discover
    case profile
    case search
    case itunesGroups
    
    /// Return:- the tab bar icon
    var icon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house.fill")
        case .discover: return UIImage(systemName: "magnifyingglass")
        case .profile: return UIImage(systemName: "person")
        case .search: return UIImage(systemName: "plus.magnifyingglass")
        case .itunesGroups: return UIImage(systemName: "scribble.variable")
        }
    }
    /// Return:- the tab bar title
    var title: String { rawValue }
    
    /// Return:-  the master/primary `topViewController`,  it instantiates a view controller using a convenient method for `UIStoryboards`.
    var masterViewController: UIViewController  {
        switch self {
        case .home: return HomeViewController(layout: layout)
        case .discover: return DiscoverViewController(layout: layout)
        case .profile: return UserProfileViewController(layout: layout)
        case .search: return SearchViewController(layout: layout)
        case .itunesGroups: return ItunesGroupsViewController(layout: layout)
        }
    }
    
    var layout: UICollectionViewLayout {
        switch self {
        case .home: return UICollectionViewCompositionalLayout.homeLayout()
        case .discover: return UICollectionViewCompositionalLayout.discoverLayout()
        case .profile: return UICollectionViewCompositionalLayout.gridProfileLayout(3)
        //   case .marvel: return UICollectionViewCompositionalLayout.gridLayout(2)
        case .search: return UICollectionViewCompositionalLayout.notificationsList(header: true)
        case .itunesGroups: return UICollectionViewCompositionalLayout.gridLayout(3, contentInsets: .zero, sectionInset: .zero, scrollAxis: .vertical) { _ in
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(100))
            return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        }
        }
    }
    
    /// - Return:-  It defines if a tab should use a `UISplitViewController` as root or not.
    var inSplitViewController: Bool {
        switch self {
        case .profile: return true
        default: return false
        }
    }
    
    //DiscoverCoordinator(rootViewController: NavigationController(rootViewController: masterViewController))
    var coordinator: Coordinator.Type {
        switch self {
        case .home: return HomeCoordinator.self
        case .discover: return DiscoverCoordinator.self
        case .search: return SearchCoordinator.self
        case .profile: return ProfileCoordinator.self
        case .itunesGroups: return ItunesGroupCoordinator.self
        }
    }
}

extension UINavigationController {
    /// - parameter viewModel: The `TabBarViewModel` element.
    func inSplitViewControllerIfSupported(for viewModel: TabBarFactory) -> UIViewController {
        
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
