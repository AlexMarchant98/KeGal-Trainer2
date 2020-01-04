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
    
    func setupAdBannerView(_ bannerView: GADBannerView, viewController: UIViewController, adId: String, bannerViewDelgate: GADBannerViewDelegate? = nil) -> GADBannerView? {
        if(!areAdsDisabled) {
            return adMobService.setupAdBannerView(bannerView, viewController, adId, bannerViewDelgate)
        }
        
        return nil
    }
    
    func displayBannerAd(_ bannerView: GADBannerView) {
        if(!areAdsDisabled) {
            adMobService.displayBannerAd(bannerView)
        }
    }
}
