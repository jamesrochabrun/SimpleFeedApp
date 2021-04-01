//
//  UISplitViewController+Extension.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

extension UISplitViewController {
    
    /// - Returns: The primary ViewController.
    var primaryViewController: UIViewController? { viewControllers.first }
    /// - Returns: The secondary ViewController.
    var secondaryViewController: UIViewController? { viewControllers.count > 1 ? viewControllers.last : nil }
    
    /// Convenience wrapper to display the detail embedded in a navigation controller if vc is not a navigation controller already.
    /// - Parameter viewController: The view controller or navigation controller that wants to be shown as secondary view controller.
    /// - Parameter sender: The sender.
    func showDetailInNavigationControllerIfNeeded(_ viewController: UIViewController, sender: Any?) {
        let detail = viewController is UINavigationController ? viewController : NavigationController(rootViewController: viewController)
        showDetailViewController(detail, sender: sender)
    }
}

extension UISplitViewController.DisplayMode {
    
    var text: String {
        switch self {
        case .allVisible: return "allVisible"
        case .automatic: return "auto"
        case .oneBesideSecondary: return "oneBesideSecondary"
        case .oneOverSecondary: return "oneOverSecondary"
        case .secondaryOnly: return "secondaryOnly"
        case .twoBesideSecondary: return "twoBesideSecondary"
        case .twoDisplaceSecondary: return "twoDisplaceSecondary"
        case .twoOverSecondary: return "twoOverSecondary"
        case .primaryHidden: return "primaryHidden"
        @unknown default: return "This is an unknown case"
        }
    }
}
