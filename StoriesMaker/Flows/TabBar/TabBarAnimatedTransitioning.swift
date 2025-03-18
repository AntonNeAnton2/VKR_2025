//
//  TabBarAnimatedTransitioning.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 29/08/2024.
//

import UIKit

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            destination.transform = .identity
            destination.alpha = 1
        } completion: { isCompleted in
            transitionContext.completeTransition(isCompleted)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
}
