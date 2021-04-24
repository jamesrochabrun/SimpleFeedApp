//
//  MainCoordinator.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/23/21.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        
    }
}



/**
 case home
 case discover
 case profile
 case search
 case itunesGroups
 */

final class SearchCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    func start() {
        
    }
}

final class DiscoverCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    func start() {
        
    }
}

final class ProfileCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    func start() {
        
    }
}

final class ItunesGroupCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    func start() {
        
    }
}
