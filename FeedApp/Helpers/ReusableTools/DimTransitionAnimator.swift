//
//  DimTransitionAnimator.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/23/21.
//

import UIKit

final class DimTransitionAnimator: NSObject {
    private let dimView = UIView()
    private let duration: CGFloat
    enum DimTransitionMode: Int {
        case present, dismiss
    }
    init(duration: CGFloat) {
        self.duration = duration
    }
    private var transitionMode: DimTransitionMode = .present
    func transitionMode(_ transMode: DimTransitionMode) {
        transitionMode = transMode
    }
}
extension DimTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionMode == .present ? presentInTransitionContext(transitionContext) : dismissInTransitionContext(transitionContext)
    }
    fileprivate func presentInTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else  {
            return
        }
        let containerView = transitionContext.containerView
        self.dimView.backgroundColor = .systemGray
        dimView.alpha = 0
        containerView.addSubview(dimView)
        containerView.addSubview(presentedView)
        dimView.fillSuperview()
        presentedView.alpha = 0
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.dimView.alpha = 1
            presentedView.alpha = 1.0
        }, completion: { (complete) in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        })
    }
    fileprivate func dismissInTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let returningView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
       // let containerView = transitionContext.containerView
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            returningView.alpha = 0
            self.dimView.alpha = 0
        }, completion: { (complete) in
            self.dimView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        })
    }
}
