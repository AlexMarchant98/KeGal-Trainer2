//
//  WalkthroughPageViewController-Animations.swift
//  PTHub
//
//  Created by Alex Marchant on 21/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension WalkthroughPageViewController {
    
    func animateScrollDown() {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            return
        }
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 3,
            options: .curveEaseInOut,
            animations: {
                self.scrollDownImage.isHidden = false
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: -30)
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: 30)
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: -30)
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: 30)
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: -30)
                self.scrollDownImage.transform = CGAffineTransform(translationX: 0, y: 30)
            }, completion: { _ in
                self.hasAnimatedScrollIndicator = true
                self.scrollDownImage.transform = CGAffineTransform.identity
                self.scrollDownImage.isHidden = true
            })
    }
    
}
