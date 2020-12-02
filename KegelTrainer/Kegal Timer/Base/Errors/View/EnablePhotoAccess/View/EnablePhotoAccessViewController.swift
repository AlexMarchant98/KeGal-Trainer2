//
//  EnablePhotoAccessViewController.swift
//  PTFinder
//
//  Created by Alex Marchant on 11/08/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

class EnablePhotoAccessViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var screenImage: UIImageView!
    @IBOutlet weak var screenTitle: KTTitle!
    @IBOutlet weak var screenDescription: KTBody!
    @IBOutlet weak var primaryButton: KTPrimaryButton!
    @IBOutlet weak var closeButton: MDCFloatingButton!
    
    var enablePhotoAccessPresenter: EnablePhotoAccessPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        self.screenImage.image = UIImage(named: "enable-photo-access")!
        self.screenTitle.text = "Enable Photo Access"
        self.screenDescription.text = "Kegel Trainer needs access to your photos so you can select your profile picture."
        self.screenDescription.textAlignment = .center
        
        closeButton.setBackgroundColor(UIColor.appLightPurple, for: .normal)
        closeButton.setTitleFont(Fonts.buttonFont, for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.setImageTintColor(UIColor.white, for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.setShadowColor(UIColor.clear, for: .normal)
        
        closeButton.setImage(UIImage(named: "close-icon")!.withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.primaryButton.setTitle("Enable", for: .normal)
        
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func primaryButtonTapped() {
        enablePhotoAccessPresenter.didTapEnablePhotoAccess()
    }
    
    @objc func closeButtonTapped() {
        enablePhotoAccessPresenter.didTapClose()
    }

}

extension EnablePhotoAccessViewController: EnablePhotoAccessPresenterView {
    
}

