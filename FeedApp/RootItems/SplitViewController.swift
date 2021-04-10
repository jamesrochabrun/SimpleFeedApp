//
//  SplitViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit

// For full explanation of this implementation please go https://medium.com/dev-genius/building-ipad-apps-prototyping-instagram-for-ipad-part-one-9ce4d03ec18a

protocol DisplayModeUpdatable {
    func displayModeWillChangeTo(_ displayMode: UISplitViewController.DisplayMode)
    func displayModeDidChangeTo(_ displayMode: UISplitViewController.DisplayMode)
}

final class SplitViewController: UISplitViewController {
    
    // MARK:- UI
    lazy var displayModeCustomButton: Button = {
        let button = Button(type: .system, image: SplitViewControllerViewModel.displayModeButtonImageFor(self.displayMode), target: self, selector: #selector(togglePrefferDisplayModeExecutingCompletion))
        button.constrainWidth(constant: 44.0)
        button.constrainHeight(constant: 44.0)
        button.imageEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    @objc private func changeDisplayMode() {
        togglePrefferDisplayModeExecutingCompletion()
    }
//
//    /**
//     Change `preferredDisplayMode` animated with a time duration of 0.25.
//     - Parameters:
//     - executing: Bool value that determines if DisplayModeUpdatable conformers should perform an update.
    //     */
    @objc func togglePrefferDisplayModeExecutingCompletion(_ executing: Bool = true) {
        UIView.animate(withDuration: 0.3, animations: {
            self.preferredDisplayMode = self.displayMode == .allVisible ? .primaryHidden : .allVisible
            self.displayModeCustomButton.setImage(SplitViewControllerViewModel.displayModeButtonImageFor(self.preferredDisplayMode), for: .normal)
            let accessibilityText = SplitViewControllerViewModel.displayModeButtonAccessibilityTextFor(self.preferredDisplayMode)
            self.displayModeCustomButton.accessibilityLabel = accessibilityText
        }) { _ in
            guard let detailViewOnDisplayModeChange = self.secondaryViewController as? UINavigationController,
                let displayModeUpdatable = detailViewOnDisplayModeChange.topViewController as? DisplayModeUpdatable
                else { return }
            displayModeUpdatable.displayModeDidChangeTo(self.displayMode)
        }
    }
    
    convenience init(viewControllers: [UIViewController]) {
        self.init()
        self.viewControllers = viewControllers
        preferredDisplayMode = .allVisible
        super.delegate = self
    }
    
    // MARK:- Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         displayModeButtonItem.customView = displayModeCustomButton
     }
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        guard let detailViewOnDisplayModeChange = svc.secondaryViewController as? UINavigationController, let displayModeUpdatable = detailViewOnDisplayModeChange.topViewController as? DisplayModeUpdatable else {
            return }
        displayModeUpdatable.displayModeWillChangeTo(displayMode)
    }
    
    /**
     - Remark: Called when App expands from `CompactWidth` to `RegularWidth` in a mulittasking enviromment.
     */
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        /// "resets the primary controller"
        if let masterAsNavigation = primaryViewController as? UINavigationController,
            let masterFirstChild = masterAsNavigation.viewControllers.first {
            masterAsNavigation.setViewControllers([masterFirstChild], animated: false)
        }
        return nil
        // "returns the last shown detail controller" (this is more important for iOS 12, for above that 14 you can return nil.)
//        guard let masterAsNavigation = primaryViewController as? UINavigationController,
//            let lastShownDetailNavigationController = masterAsNavigation.viewControllers.last as? UINavigationController,
//            let lastShownDetailContentViewController = lastShownDetailNavigationController.viewControllers.first else { return nil }
//        return type(of: lastShownDetailNavigationController).init(rootViewController: lastShownDetailContentViewController)
    }
    
    /**
     - Remark: Called when App collapses from `RegularWidth` to `CompactWidth` in a mulittasking enviromment.
     */
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return secondaryViewController is EmptyDetailViewController
        
    }
}

struct SplitViewControllerViewModel {
    
    static func displayModeButtonImageFor(_ displayMode: UISplitViewController.DisplayMode) -> UIImage? {
        displayMode == .allVisible ? UIImage(systemName: "arrow.up.left.and.arrow.down.right") : UIImage(systemName: "arrow.down.right.and.arrow.up.left")
    }
    
    static func displayModeButtonAccessibilityTextFor(_ displayMode: UISplitViewController.DisplayMode) -> String {
        displayMode == .allVisible ? "Expand Detail Screen" : "Collapse Detail Screen"
    }
    
}
