//
//  LoadingView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private (set) var viewHasBeenSetup = false
    private (set) var loadingIsShown = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewBounds()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViewBounds()
        
        setupView()
    }
    
    func setupViewBounds() {
        
        if(!viewHasBeenSetup) {
            let name = String(describing: type(of: self))
            
            Bundle.main.loadNibNamed(name, owner: self, options: nil)
            
            self.addSubview(self.view)
            
            self.view.frame = self.bounds
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            viewHasBeenSetup = true
        }
    }
    
    func setupView() {
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        activityIndicator.color = .white
        
        setLoading(isLoading: false)
    }
    
    func setLoading(isLoading: Bool) {
        
        self.loadingIsShown = isLoading
        
        self.isHidden = !isLoading
        self.view.isHidden = !isLoading
        activityIndicator.isHidden = !isLoading
        
        if(isLoading) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

