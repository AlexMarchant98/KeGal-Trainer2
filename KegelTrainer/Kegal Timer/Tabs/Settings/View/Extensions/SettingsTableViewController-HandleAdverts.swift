//
//  SettingsTableViewController-HandleAdverts.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork

extension SettingsTableViewController {
    
    func setupAdvertArea() {
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        
        if let bannerView = self.adServer.setupAdMobBannerView(
            adId: Constants.settingsTabBannerAdId,
            viewController: self,
            bannerContainerView: self.tableView!.tableHeaderView!) {
            
            self.adBannerView = bannerView
        }
        if let returnedAudienceNetworkBannerView = self.adServer.setupAudienceNetworkBannerView(
            placementId: Constants.audienceNetworkTabsBannerAdPlacementId,
            viewController: self,
            bannerContainerView: self.tableView!.tableHeaderView!) {
            
            self.audienceNetworkBannerView = returnedAudienceNetworkBannerView
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}
