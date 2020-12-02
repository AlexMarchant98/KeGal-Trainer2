//
//  DailyPointsView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class DailyPointsView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var dailyPointsHeader: KTHeader!
    @IBOutlet weak var dailyPointsProgress: UIProgressView!
    @IBOutlet weak var pointsLabel: KTBody!
    
    var model: DailyPointsViewModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            self.pointsLabel.text = "\(model.pointsEarnedToday) / \(Constants.maxDailyPoints)"
            
            let progress = Float(model.pointsEarnedToday) / Float(Constants.maxDailyPoints)
            
            self.dailyPointsProgress.setProgress(progress, animated: true)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.backgroundColour
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.backgroundColour
        
        self.dailyPointsHeader.textColor = .appGreen
        self.pointsLabel.textColor = .appGreen
        self.pointsLabel.text = "0 / \(Constants.maxDailyPoints)"
        
        self.dailyPointsProgress.setProgress(0, animated: false)
        self.dailyPointsProgress.progressTintColor = UIColor.appGreen
        self.dailyPointsProgress.trackTintColor = UIColor.appGreen.withAlphaComponent(0.30)
    }

}

