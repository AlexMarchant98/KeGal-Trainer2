//
//  CurrentWorkoutStreakView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol DailyStreakViewDelegate {
    func buyStreakProtector()
}

class CurrentWorkoutStreakView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var currentWorkoutStreakHeader: KTHeader!
    @IBOutlet weak var currentStreakLabel: KTBody!
    @IBOutlet weak var streakProtectorsImageView: UIImageView!
    @IBOutlet weak var streakProtectorsLeftLabel: KTSubHeader!
    @IBOutlet weak var streakProtectorDescriptionLabel: KTBody!
    @IBOutlet weak var getStreakProtectorButton: KTSecondaryButton!
    
    var delegate: DailyStreakViewDelegate?
    
    var model: CurrentWorkoutStreakViewModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            self.delegate = model.delegate
            
            self.currentStreakLabel.text = "\(model.streak) days"
            
            if(model.streakProtectors == 1) {
                streakProtectorsLeftLabel.text = "\(model.streakProtectors) Streak Protector Left"
            } else {
                streakProtectorsLeftLabel.text = "\(model.streakProtectors) Streak Protectors Left"
            }
            
            if(model.streakProtectors <= 1) {
                self.streakProtectorDescriptionLabel.isHidden = false
            } else {
                self.streakProtectorDescriptionLabel.isHidden = true
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
        
        let shieldIcon = UIImage(named: "shield-icon")?.withRenderingMode(.alwaysTemplate)
        
        self.streakProtectorsImageView.image = shieldIcon
        self.streakProtectorsImageView.tintColor = UIColor.rgb(r: 255, g: 0, b: 167)
        self.streakProtectorsImageView.backgroundColor = .clear
        
        self.streakProtectorsLeftLabel.textColor = UIColor.rgb(r: 255, g: 0, b: 167)
        
        self.streakProtectorDescriptionLabel.textColor = .white
        
        self.currentWorkoutStreakHeader.textColor = .appGreen
        self.currentStreakLabel.textColor = .appGreen
        self.currentStreakLabel.textColor = .appGreen
    }
    
    @IBAction func getStreakProtector(_ sender: Any) {
        self.delegate?.buyStreakProtector()
    }
    
    func setLoading(_ isLoading: Bool) {
        getStreakProtectorButton.isEnabled = !isLoading
    }

}
