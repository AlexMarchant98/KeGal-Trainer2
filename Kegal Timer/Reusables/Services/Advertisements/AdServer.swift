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
import FBAudienceNetwork

class AdServer {
    
    let areAdsDisabled: Bool!
    
    var adMobService: AdMobService!
    var audienceNetworkService: AudienceNetworkService!
    
    init() {
        self.areAdsDisabled = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        if(!self.areAdsDisabled) {
            self.adMobService = AdMobService(delegate: self)
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
    
    func setupAdMobBannerView(
        adId: String,
        viewController: UIViewController,
        bannerContainerView: UIView) -> GADBannerView? {
        if(!areAdsDisabled) {
            return adMobService.setupAdBannerView(adId, viewController, bannerContainerView)
        }
        
        return nil
    }
    
    func setupAudienceNetworkBannerView(
        placementId: String,
        viewController: UIViewController,
        bannerContainerView: UIView) -> FBAdView? {
        if(!areAdsDisabled) {
            return audienceNetworkService.setupAdBannerView(placementId, viewController, bannerContainerView)
        }
        
        return nil
    }
}

extension AdServer: AdMobServiceDelegate {
    func didFailToLoadAdMobBanner() {
        <#code#>
    }
    
    func didFailToLoadAdMobInterstitial() {
        <#code#>
    }
    
    
}
