//
//  KTTableHeaderView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class KTTableHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: KTHeader!
    
    private (set) var viewHasBeenSetup = false
    private (set) var loadingIsShown = false
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        setupViewBounds()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
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
    
    override var intrinsicContentSize: CGSize {
        
        setupViewBounds()
        setupView()
        
        let originContentSize = super.intrinsicContentSize
        
        let width = originContentSize.width
        let height = originContentSize.height
        
        layer.masksToBounds = true
        
        return CGSize(width: width, height: height)
    }
    
    func setupView() {
        titleLabel.textColor = .white
    }
    
}
