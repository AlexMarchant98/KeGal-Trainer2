//
//  ViewLeaderboardView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 23/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol ViewLeaderboardViewDelegate {
    func viewLeaderboard()
}

class ViewLeaderboardView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var viewLeaderboardButton: KTSecondaryButton!
    
    var delegate: ViewLeaderboardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = .clear
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = .clear
    }
    
    @IBAction func reviewAppButtonTapped(_ sender: Any) {
        self.delegate?.viewLeaderboard()
    }


}

