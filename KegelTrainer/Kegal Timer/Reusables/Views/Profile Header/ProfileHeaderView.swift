//
//  ProfileHeaderView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    func editProfile()
}

class ProfileHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var username: KTTitle!
    @IBOutlet var profilePicture: KTProfilePicture!
    @IBOutlet var totalPointsLabel: KTSubTitle!
    @IBOutlet var joinDateLabel: KTBody!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    var delegate: ProfileHeaderViewDelegate?
    
    var model: ProfileHeaderViewModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            self.delegate = model.delegate
            self.username.text = model.username
            self.totalPointsLabel.text = "\(model.totalPoints) points"
            self.joinDateLabel.text = "Joined: \(model.joinDate)"
            
            if let url = model.profilePictureUrl {
                let _ = model.firebaseCloudStorageService.read(documentUrl: url, imageView: profilePicture)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
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
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.appLightPurple.cgColor, UIColor.appDarkPurple.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
            
        self.view.addBottomRoundedEdge(desiredCurve: 1.25)
        
        self.profilePicture.image = UIImage(named: "profile-placeholder")
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height / 2
        
        let editIcon = UIImage(named: "edit-icon")?.withRenderingMode(.alwaysTemplate)
        
        self.editButton.setTitle("", for: .normal)
        self.editButton.setImage(nil, for: .normal)
        self.editButton.setBackgroundImage(editIcon, for: .normal)
        self.editButton.tintColor = UIColor.white
        self.editButton.backgroundColor = .clear
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.delegate?.editProfile()
    }
    
}
