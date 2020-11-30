//
//  KTProfilePicture.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 15/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class KTProfilePicture: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.image = UIImage(named: "profile-placeholder")!
    }

}
