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
    
    var coordinators: [Coordinator] = [] /// holds a reference to the coordinators, so then conformers can have the corrdinator set to `weak`
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var coordinators: [Coordinator] = []
        var topViewControllers: [UIViewController] = []
        
        for i in TabBarFactory.allCases.indices {
            let factoryKind = TabBarFactory.allCases[i]
            let coordinator = factoryKind.coordinator.init(rootViewController: NavigationController(rootViewController: factoryKind.masterViewController))
            coordinators.append(coordinator)
            let topViewController = coordinator.rootViewController.inSplitViewControllerIfSupported(for: factoryKind)
            topViewControllers.append(topViewController)
        }

        self.coordinators = coordinators
        coordinators.forEach { $0.start() }
        viewControllers = topViewControllers
    }
}
