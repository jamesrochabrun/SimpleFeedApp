//
//  HomeCoordinator.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/25/21.
//

import UIKit

final class HomeCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        rootViewController.delegate = self
        (self.rootViewController.topViewController as? HomeViewController)!.coordinator = self
    }
    
    func showDetail() {
        let child = DetailPageCoordinator(rootViewController: rootViewController)
        child.parentCoordinator = self
        children.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromVC) { return }
        if let detailViewController = fromVC as? DetailPageViewController {
            childDidFinish(detailViewController.coordinator)
        }
    }
}
