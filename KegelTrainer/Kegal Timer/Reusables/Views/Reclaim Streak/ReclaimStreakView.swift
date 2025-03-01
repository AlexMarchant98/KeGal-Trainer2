//
//  ReclaimStreakView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol ReclaimStreakViewDelegate {
    func reclaimStreak()
}

class ReclaimStreakView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var viewStack: UIStackView!
    @IBOutlet weak var reclaimStreakHeader: KTSubTitle!
    @IBOutlet weak var reclaimStreakDescription: KTHeader!
    @IBOutlet weak var reclaimStreakButton: KTPrimaryButton!
    
    var delegate: ReclaimStreakViewDelegate?
    
    var model: ReclaimStreakViewModel? {
        didSet {
            
            viewStack.isHidden = true
            viewStack.isUserInteractionEnabled = false
            
            guard let model = model else {
                return
            }
            
            delegate = model.delegate
            
            if(model.hasStreakToReclaim) {
                if let daysLeft = model.daysLeftToReclaimStreak,
                   let lostStreak = model.lostStreak {
                    
                    var streakLostText: String = ""
                    var daysLeftToReclaimText: String = ""
                    
                    if(lostStreak == 1) {
                        streakLostText = "You lost your previous streak of \(lostStreak) day!"
                    } else {
                        streakLostText = "You lost your previous streak of \(lostStreak) days!"
                    }
                    
                    if(daysLeft == 1) {
                        daysLeftToReclaimText = "You have \(daysLeft) day left to save this streak before you lose it forever and have to start again!"
                    } else {
                        daysLeftToReclaimText = "You have \(daysLeft) days left to save this streak before you lose it forever and have to start again!"
                    }
                    // Handle if the streak or days left is 1
                    
                    let streakMultiplier = ((0.65 * Double(lostStreak)) * 100).rounded() / 100
                    
                    reclaimStreakDescription.text = "\(streakLostText)\n\n\(daysLeftToReclaimText)\n\nThis streak would multiply the points you earn per workout by \(streakMultiplier) times!\n\nSave it now!"
                    
                    viewStack.isHidden = false
                    viewStack.isUserInteractionEnabled = true
                }
            }
            
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
        
        reclaimStreakHeader.textColor = .white
        
        viewStack.isHidden = true
        viewStack.isUserInteractionEnabled = false
        
    }
    
    @IBAction func reclaimStreakButtonTapped(_ sender: Any) {
        self.delegate?.reclaimStreak()
    }


}

