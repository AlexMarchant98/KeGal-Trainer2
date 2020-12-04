//
//  ChatsWalkthroughViewController.swift
//  PTFinder
//
//  Created by Alex Marchant on 28/07/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate {
    func nextTapped()
}

class WalkthroughPageViewController: UIViewController, Storyboarded {
    
    private (set) var stepImage: UIImage = UIImage(named: "welcome")!
    private (set) var stepTitle: String = ""
    private (set) var stepDescription: String = ""
    private (set) var buttonText: String = localizedString(forKey: "next")
    
    var delegate: WalkthroughPageViewControllerDelegate?
    
    var hasAnimatedScrollIndicator: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollDownImage: UIImageView!
    @IBOutlet weak var screenImage: UIImageView!
    @IBOutlet weak var screenTitle: KTSubTitle!
    @IBOutlet weak var screenDescription: KTBody!
    @IBOutlet weak var nextButton: KTPrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        self.scrollView.backgroundColor = .workoutBackgroundColor
        
        self.screenImage.image = stepImage
        self.screenTitle.text = stepTitle
        self.screenDescription.text = stepDescription
        
        self.scrollDownImage.image = UIImage(named: "down-arrow-icon")!.withRenderingMode(.alwaysTemplate)
        self.scrollDownImage.tintColor = .appGreen
        
        self.scrollDownImage.isHidden = true
        
        self.screenDescription.textAlignment = .center
        
        self.nextButton.layer.cornerRadius = Constants.cornerRadius
        self.nextButton.setTitle(buttonText, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!hasAnimatedScrollIndicator) {
            animateScrollDown()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.delegate?.nextTapped()
    }
    
    func setupScreenInformation(
        imageName: String,
        stepTitle: String,
        stepDescription: String,
        buttonText: String = localizedString(forKey: "next"),
        delegate: WalkthroughPageViewControllerDelegate) {
        
        self.stepImage = UIImage(named: imageName)!
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.hasAnimatedScrollIndicator = false
        self.buttonText = buttonText
        self.delegate = delegate
    }

}
