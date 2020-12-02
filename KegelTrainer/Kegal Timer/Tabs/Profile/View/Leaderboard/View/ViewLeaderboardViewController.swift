//
//  ViewLeaderboardViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class ViewLeaderboardViewController: UIViewController, Storyboarded {
    
    var viewLeaderboardPresenter: ViewLeaderboardPresenterProtocol!
    
    @IBOutlet weak var backButton: MDCFloatingButton!
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak private var rankLabel: KTSubTitle!
    @IBOutlet weak private var profilePictureView: KTProfilePicture!
    @IBOutlet weak private var usernameLabel: KTHeader!
    @IBOutlet weak private var pointsLabel: KTSubHeader!
    
    var leaderboardDataSource: LeaderboardDataSource?
    
    lazy var backSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeLeaderboard))
        recognizer.direction = .right
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        self.leaderboardCollectionView.backgroundColor = .clear
        self.leaderboardCollectionView.isScrollEnabled = true
        
        viewLeaderboardPresenter.getInitialLeaderboardSet()
        viewLeaderboardPresenter.getMyRank()
        
        backButton.setBackgroundColor(UIColor.clear, for: .normal)
        backButton.setTitleFont(Fonts.buttonFont, for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.setImageTintColor(UIColor.white, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.setShadowColor(UIColor.clear, for: .normal)
        
        backButton.setImage(UIImage(named: "back-icon")!.withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.view.addGestureRecognizer(backSwipeGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        closeLeaderboard()
    }
    
    @objc func closeLeaderboard() {
        viewLeaderboardPresenter.closeLeaderboard()
    }

}

extension ViewLeaderboardViewController: ViewLeaderboardPresenterView {
    
    func didGetInitalProfileSet(_ profiles: [FIRProfile], _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol) {
        
        
        if let rank = CurrentUserService.shared.user!.rank {
            rankLabel.text = "\(rank)"
        } else {
            rankLabel.text = "Unranked"
        }
        
        usernameLabel.textColor = .white
        usernameLabel.text = "\(CurrentUserService.shared.user!.username)"
        pointsLabel.text = "\(CurrentUserService.shared.user!.total_points) points"
        
        if let url = CurrentUserService.shared.user!.profile_picture {
            let _ = firebaseCloudStorageService.read(documentUrl: URL(string: url)!, imageView: profilePictureView)
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.appLightPurple.cgColor, UIColor.appDarkPurple.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: myProfileView.frame.size.width, height: myProfileView.frame.size.height)
        gradient.cornerRadius = 10
        
        myProfileView.layer.insertSublayer(gradient, at: 0)
        myProfileView.layer.cornerRadius = 10
        myProfileView.backgroundColor = .clear
        
        self.leaderboardDataSource = LeaderboardDataSource(
            firebaseCloudStorageService,
            profiles: profiles,
            collectionView: self.leaderboardCollectionView,
            delegate: self)
        
        self.leaderboardCollectionView.dataSource = leaderboardDataSource
        self.leaderboardCollectionView.delegate = leaderboardDataSource
        self.leaderboardCollectionView.reloadData()
    }
    
    func didGetLeaderboardSet(_ profiles: [FIRProfile]) {
        self.leaderboardDataSource?.addProfileSet(profileSet: profiles)
    }
    
    func didGetCurrentUserRank(_ rank: Int) {
        // Set the rank on the card to be this rank returned
    }
    
    func allProfilesLoaded() {
        self.leaderboardDataSource?.setAllAccountsLoaded(true)
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}

extension ViewLeaderboardViewController: LeaderboardDataSourceDelegate {
    func loadNextProfileSet() {
        self.viewLeaderboardPresenter.loadNextProfileSet()
    }
}
