//
//  ConnectionRequiredViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

class ConnectionRequiredViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var screenImage: UIImageView!
    @IBOutlet weak var screenTitle: KTTitle!
    @IBOutlet weak var screenDescription: KTBody!
    @IBOutlet weak var primaryButton: KTPrimaryButton!
    @IBOutlet weak var closeButton: MDCFloatingButton!
    
    var connectionRequiredPresenter: ConnectionRequiredPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColour
        
        self.screenImage.image = UIImage(named: "login")!
        self.screenTitle.numberOfLines = 0
        self.screenTitle.text = "Internet Connection Required"
        self.screenDescription.text = "To use the app, you must have an internet connection."
        self.screenDescription.textAlignment = .center
        
        self.primaryButton.setTitle("Retry", for: .normal)
        
        self.closeButton.isEnabled = false
        self.closeButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func primaryButtonTapped() {
        self.setLoading(isLoading: true)
        connectionRequiredPresenter.didTapRetryConnection()
    }
    
    func setLoading(isLoading: Bool) {
        self.primaryButton.isEnabled = !isLoading
    }

}

extension ConnectionRequiredViewController: ConnectionRequiredPresenterView {
    func connectionNotFound() {
        self.setLoading(isLoading: false)
    }
}

