//
//  AdServer.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/01/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdServer {
    
    let areAdsDisabled: Bool!
    
    var adMobService: AdMobService!
    var audienceNetworkService: AudienceNetworkService!
    
    init() {
        self.areAdsDisabled = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        if(!self.areAdsDisabled) {
            self.adMobService = AdMobService()
            self.audienceNetworkService = AudienceNetworkService()
        }
    }
    
    func reloadAds() {
        if(!areAdsDisabled) {
            self.adMobService.loadAds()
            self.audienceNetworkService.loadAds()
        }
    }
    
    func displayInterstitialAd(viewController: UIViewController) {
        if(!areAdsDisabled) {
            let adDisplayed = adMobService.displayGADInterstitial(viewController)
            
            if(!adDisplayed) {
                audienceNetworkService.displayAudienceNetworkInterstitial(viewController)
            }
        }
    }
    
    func setupAdBannerView(
        adId: String,
        viewController: UIViewController,
        bannerContainerView: UIView) -> GADBannerView? {
        if(!areAdsDisabled) {
            return adMobService.setupAdBannerView(adId, GADAdSize(size: bannerContainerView.frame.size, flags: 0), viewController, bannerContainerView)
        }
        
        return nil
    }
}
