//
//  DetailPageCoordinator.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/25/21.
//

import UIKit


final class DetailPageCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
 
    weak var parentCoordinator: HomeCoordinator?
    
    var children: [Coordinator] = []
    var rootViewController: UINavigationController
    private lazy var transition = DimTransitionAnimator(duration: 0.3)
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    var detailImage: UIImage?
    
    func start() {
        // if pushed from `rootViewController` the work of removing child coordinatora can be done from the `UINavigationControllerDelegate`
        // if presented, the wotk can be done from `UIAdaptivePresentationControllerDelegate` and you must implement something also for the case where the vc is not dragged.
        // if custom presented we can do the work inside the `UIViewControllerTransitioningDelegate
        
        let vc = DetailPageViewController()
        vc.detailImage = detailImage
        vc.coordinator = self
        let nav = UINavigationController(rootViewController: vc)
        /// setting this property will result in implementing a presentation with and aditional animation , (not ideal)
//        nav.presentationController?.delegate = self
        nav.delegate = self
        vc.view.backgroundColor = .green
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = self
        if let splitVC = rootViewController.splitViewController {
            splitVC.showDetailInNavigationControllerIfNeeded(vc, sender: self)
        } else {
          //  rootViewController.pushViewController(vc, animated: true)
          //  rootViewController.showDetailViewController(nav, sender: self)
         //   rootViewController.present(nav, animated: true)
            rootViewController.topViewController?.present(nav, animated: true)
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let detailViewController = (presentationController.presentedViewController as? UINavigationController)?.topViewController as? DetailPageViewController {
            parentCoordinator?.childDidFinish(detailViewController.coordinator)
        }
    }
}

extension DetailPageCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode(.present)
         return transition
     }
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode(.dismiss)
         return transition
     }
}
