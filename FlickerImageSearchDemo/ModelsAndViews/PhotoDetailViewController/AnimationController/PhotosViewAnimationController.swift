//
//  PhotosViewAnimationController.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 03/02/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

class PhotosViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let mainView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : mainView.frame
        let finalFrame = presenting ? mainView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            mainView.transform = scaleTransform
            mainView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            mainView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(mainView)
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                       animations: {
                        mainView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        mainView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })

    }
       
    func animationEnded(_ transitionCompleted: Bool) {
        print("Animation ended")
    }
}
