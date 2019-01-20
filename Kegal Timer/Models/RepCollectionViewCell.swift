//
//  RepCollectionViewCell.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 18/12/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

public class RepCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var repCount: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.repCount)
        self.repCount.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
