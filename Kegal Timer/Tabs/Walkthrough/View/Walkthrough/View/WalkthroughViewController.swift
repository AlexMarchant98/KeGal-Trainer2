//
//  WalkthroughViewController.swift
//  PTHub
//
//  Created by Alex Marchant on 20/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, Storyboarded {
    
    var orderedWalkthroughSteps = [WalkthroughPageViewController]()
    
    var hasLaunchedBefore: Bool = false
    
    var pageViewController: UIPageViewController?
    var pageControl: UIPageControl?
    
    var walkthroughPresenter: WalkthroughPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        setupPageController()
        
        setupWalkthroughViewControllers()
        
        if(!hasLaunchedBefore) {
            addWelcomeViewController()
        }
        
        if let firstViewController = orderedWalkthroughSteps.first {
            pageViewController!.setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
        
        configurePageControl()
        
    }
    
    func setupPageController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.pageViewController?.dataSource = self
        self.pageViewController?.delegate = self
        
        self.pageViewController?.view.backgroundColor = .white
        
        if(self.view.frame.height > 700) {
            self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.height - 250)
        } else {
            self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.height - 150)
        }
        
        self.pageViewController?.view.center = self.view.center
        
        self.pageViewController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.pageViewController?.view.layer.cornerRadius = 5
        self.pageViewController?.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.addChild(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        self.pageViewController?.didMove(toParent: self)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: self.pageViewController!.view!, attribute: .centerX, relatedBy: .equal, toItem: self.view!, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.pageViewController!.view!, attribute: .centerY, relatedBy: .equal, toItem: self.view!, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
    func configurePageControl() {
        
        if(self.view.frame.height > 700) {
            pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.bounds.height - 100, width: self.view.bounds.width, height: 50))
        } else {
            pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 50))
        }
        
        self.pageControl!.numberOfPages = orderedWalkthroughSteps.count
        self.pageControl!.currentPage = 0
        self.pageControl!.tintColor = UIColor.darkGray
        self.pageControl!.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl!.currentPageIndicatorTintColor = UIColor.darkGray
        self.pageControl!.isUserInteractionEnabled = false
        
        self.view.addSubview(pageControl!)
    }
    
    func isLastPage(_ nextIndex: Int) -> Bool {
        let pageCount = orderedWalkthroughSteps.count
        
        if(nextIndex >= pageCount) {
            return true
        }
        
        return false
    }

}

extension WalkthroughViewController: WalkthroughPresenterView { }

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    func nextTapped() {
        let nextIndex = self.pageControl!.currentPage + 1
        
        if (isLastPage(nextIndex)) {
            walkthroughPresenter.closeWalkthrough()
        } else {
            self.pageViewController!.setViewControllers(
                [self.orderedWalkthroughSteps[nextIndex]],
                direction: .forward,
                animated: true,
                completion: nil)
            
            self.pageControl!.currentPage = nextIndex
        }
    }
}

// MARK: UIPageViewControllerDataSource

extension WalkthroughViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? WalkthroughPageViewController else {
            return nil
        }
        
        guard let viewControllerIndex = orderedWalkthroughSteps.firstIndex(of: vc) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return orderedWalkthroughSteps[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? WalkthroughPageViewController else {
            return nil
        }
        
        guard let viewControllerIndex = orderedWalkthroughSteps.firstIndex(of: vc) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        if (isLastPage(nextIndex)) {
            return nil
        }
        
        return orderedWalkthroughSteps[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = self.pageViewController?.viewControllers?[0] as? WalkthroughPageViewController else {
            return
        }
        
        guard let index = orderedWalkthroughSteps.firstIndex(of: vc) else {
            return
        }
        
        self.pageControl!.currentPage = index
    }
    
}
