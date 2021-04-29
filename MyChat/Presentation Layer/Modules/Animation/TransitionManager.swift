//
//  TransitionManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.04.2021.
//

import UIKit

protocol ITransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, ITransitionManager {

    private var isPresenting = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        present(using: transitionContext)
    }
    
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view else {
            transitionContext.completeTransition(false)
            return
        }
        
//        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: container.frame.height)
//        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: -container.frame.height)
        let offScreenRight = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        let offScreenLeft = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        
        let transitionTo = isPresenting ? offScreenRight : offScreenLeft
        let transitionFrom = isPresenting ? offScreenLeft : offScreenRight
        
        toView.transform = transitionTo
        toView.alpha = 0
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            toView.alpha = 1
            fromView.alpha = 0
            fromView.transform = transitionFrom
            toView.transform = CGAffineTransform.identity

        } completion: { finished in
            transitionContext.completeTransition(finished)
            UIApplication.shared.keyWindow?.addSubview(toView)
        }
    }
}

extension TransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
