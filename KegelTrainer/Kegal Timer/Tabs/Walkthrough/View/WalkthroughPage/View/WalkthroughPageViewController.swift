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
    private (set) var stepTitle: String = "Title"
    private (set) var stepDescription: String = "Description"
    private (set) var buttonText: String = "Next"
    
    var delegate: WalkthroughPageViewControllerDelegate?
    
    var hasAnimatedScrollIndicator: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollDownImage: UIImageView!
    @IBOutlet weak var screenImage: UIImageView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenImage.image = stepImage
        self.screenTitle.text = stepTitle
        self.screenDescription.text = stepDescription
        
        self.scrollDownImage.image = UIImage(named: "down-arrow-icon")!.withRenderingMode(.alwaysTemplate)
        
        self.scrollDownImage.isHidden = true
        
        self.screenDescription.textAlignment = .center
        
        self.nextButton.layer.cornerRadius = 5
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
        buttonText: String = "Next",
        delegate: WalkthroughPageViewControllerDelegate) {
        
        self.stepImage = UIImage(named: imageName)!
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.hasAnimatedScrollIndicator = false
        self.buttonText = buttonText
        self.delegate = delegate
    }

}
