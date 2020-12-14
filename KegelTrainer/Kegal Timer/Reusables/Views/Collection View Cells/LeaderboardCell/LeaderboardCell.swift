//
//  LeaderboardCell.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class LeaderboardCell: UICollectionViewCell {
    
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var rankLabel: KTSubTitle!
    @IBOutlet weak private var profilePictureView: KTProfilePicture!
    @IBOutlet weak private var usernameLabel: KTHeader!
    @IBOutlet weak private var pointsLabel: KTSubHeader!
    
    var model: LeaderboardCellViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            if let rank = model.rank {
                rankLabel.text = "\(rank)"
            } else {
                rankLabel.text = "Unranked"
            }
            
            switch model.rank {
            case 1:
                self.backgroundColor = .appGreen
            case 2:
                self.backgroundColor = .rgb(r: 178, g: 49, b: 49)
            case 3:
                self.backgroundColor = .rgb(r: 178, g: 116, b: 0)
            default:
                self.backgroundColor = .leaderboardGray
            }
            
            usernameLabel.text = "\(model.username)"
            pointsLabel.text = "\(model.points) points"
            
            if let url = model.profilePictureUrl {
                let _ = model.firebaseCloudStorageSerivce.read(documentUrl: url, imageView: profilePictureView)
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.layer.cornerRadius = 10
        
        self.rankLabel.text = "0000"
        self.rankLabel.textColor = .white
        
        self.profilePictureView.image = UIImage(named: "profile-placeholder")
        
        self.usernameLabel.text = "username"
        self.usernameLabel.numberOfLines = 1
        self.usernameLabel.textColor = .white
        
        self.pointsLabel.text = "0 points"
        self.pointsLabel.textColor = .white
    }
    
    func resetCellUI() {
        self.rankLabel.text = "0000"
        self.profilePictureView.image = UIImage(named: "profile-placeholder")
        self.usernameLabel.text = "username"
        self.pointsLabel.text = "0 points"
    }

}
