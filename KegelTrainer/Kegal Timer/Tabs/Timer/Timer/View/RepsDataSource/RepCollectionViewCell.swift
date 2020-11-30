//
//  RepCollectionViewCell.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 18/12/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

public class RepCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var repCount: KTSubHeader!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.repCount)
        self.repCount.textAlignment = .center
    }
}
