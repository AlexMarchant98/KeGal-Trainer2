//
//  LeaderboardDataSource.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol LeaderboardDataSourceDelegate {
    func loadNextProfileSet()
}

class LeaderboardDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private (set) var profiles = [FIRProfile]()
    private (set) var allAccountsLoaded = false
    
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    let collectionView: UICollectionView
    let delegate: LeaderboardDataSourceDelegate
    
    init(
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        profiles: [FIRProfile],
        collectionView: UICollectionView,
        delegate: LeaderboardDataSourceDelegate) {
        
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.collectionView = collectionView
        self.delegate = delegate
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 25
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: Constants.leaderboardCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.leaderboardCellIdentifier)
        
        self.profiles = profiles
    }
    
    func addProfileSet(profileSet: [FIRProfile]) {
        self.profiles.append(contentsOf: profileSet)
        
        self.collectionView.reloadData()
    }
    
    func setAllAccountsLoaded(_ allAccountsLoaded: Bool) {
        self.allAccountsLoaded = allAccountsLoaded
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.leaderboardCellIdentifier, for: indexPath) as! LeaderboardCell
        
        cell.resetCellUI()
        
        if indexPath.row < profiles.count {
            let profile = profiles[indexPath.row]
            let model = LeaderboardCellViewModel(
                rank: indexPath.row + 1,
                points: profile.total_points,
                username: profile.username,
                firebaseCloudStorageService,
                profilePictureUrl: profile.profile_picture)
            
            cell.model = model
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if(profiles.isEmpty) {
            return
        }
        
        if(indexPath.item == profiles.count - 1 && allAccountsLoaded == false) {
            self.delegate.loadNextProfileSet()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 80)
    }
    
}

//extension LeaderboardDataSource: SkeletonCollectionViewDataSource {
//
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "LeaderboardCell"
//    }
//}
