//
//  ProfileInfoCardView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class ProfileInfoCardView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var label: KTSubHeader!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupView()
    }
    
    func setupView() {
        self.view.layer.cornerRadius = Constants.cornerRadius
        self.view.backgroundColor = UIColor.appGreen
        self.label.textColor = .backgroundColour
    }
    
    func setClickable() {
        self.view.backgroundColor = UIColor.appLightPurple
        self.label.textColor = UIColor.white
    }
    
    func setLeaderboard() {
        self.view.backgroundColor = UIColor.leaderboardGray
        self.label.textColor = UIColor.white
    }

}
