//
//  ProfileTotalsView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol ProfileTotalsViewDelegate {
    func showWorkoutTracker()
}

class ProfileTotalsView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var totalsHeader: KTHeader!
    @IBOutlet weak var totalWorkoutsSubHeader: KTSubHeader!
    @IBOutlet weak var totalWorkoutTimeSubHeader: KTSubHeader!
    @IBOutlet weak var totalWorkoutsCard: ProfileInfoCardView!
    @IBOutlet weak var totalWorkoutTimeCard: ProfileInfoCardView!
    @IBOutlet weak var showWorkoutTrackerButton: KTSecondaryButton!
    
    var delegate: ProfileTotalsViewDelegate?
    
    var model: ProfileTotalsViewModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            self.delegate = model.delegate
            
            totalWorkoutsCard.label.text = "\(model.totalWorkouts)"
            
            let minutes: Int64 = model.totalWorkoutTime / 60
            
            if(minutes < 60) {
                let remainingSeconds: Int64 = model.totalWorkoutTime - (60 * minutes)
                
                if(minutes == 0) {
                    totalWorkoutTimeCard.label.text = "\(minutes) minute \(remainingSeconds) seconds"
                } else {
                    totalWorkoutTimeCard.label.text = "\(minutes) minutes \(remainingSeconds) seconds"
                }
                
            } else {
                
                let hours: Int64 = minutes / 60
                let remainingMinutes: Int64 = (model.totalWorkoutTime - (60 * 60 * hours)) / 60
                
                if(hours == 1) {
                    totalWorkoutTimeCard.label.text = "\(hours) hour \(remainingMinutes) minutes"
                } else {
                    totalWorkoutTimeCard.label.text = "\(hours) hours \(remainingMinutes) minutes"
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
        
        self.totalsHeader.textColor = .appGreen
        self.totalWorkoutsSubHeader.textColor = .appGreen
        self.totalWorkoutTimeSubHeader.textColor = .appGreen
    }
    
    @IBAction func showWorkoutTracker(_ sender: Any) {
        self.delegate?.showWorkoutTracker()
    }

}


