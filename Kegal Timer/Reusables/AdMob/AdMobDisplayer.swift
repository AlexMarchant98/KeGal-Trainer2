//
//  AdMobDisplayer.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 15/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMobDisplayer {
    var interstitial: GADInterstitial?
    
    var bannerAdRequest: GADRequest!
    var interstitialAdRequest: GADRequest!
    
    var areAdsDisabled: Bool!
    
    init() {
        self.areAdsDisabled = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        self.bannerAdRequest = GADRequest()
        self.interstitialAdRequest = GADRequest()
    }
    
    func setupGadInterstitial(adUnitID: String) {
        if(!areAdsDisabled) {
            self.interstitial = GADInterstitial(adUnitID: adUnitID)
            self.interstitial!.load(self.interstitialAdRequest)
        }
    }
    
    func displayGADInterstitial(viewController: UIViewController) {
        if(!areAdsDisabled) {
            if self.interstitial?.isReady ?? false {
                self.interstitial!.present(fromRootViewController: viewController)
            } else {
                print("Ad wasn't ready")
            }
        }
    }
    
    func setupAdBannerView(_ bannerView: GADBannerView, viewController: UIViewController, adUnitId: String, bannerViewDelgate: GADBannerViewDelegate? = nil) -> GADBannerView {
        if(!areAdsDisabled) {
            bannerView.adUnitID = adUnitId
//            bannerView.adUnitID = Constants.testBannerAdId
            bannerView.rootViewController = viewController
            
            if let delegate = bannerViewDelgate {
                bannerView.delegate = delegate
            }
        }
        
        return bannerView
    }
    
    func displayBannerAd(_ bannerView: GADBannerView) {
        if(!areAdsDisabled) {
            bannerView.load(self.bannerAdRequest)
        }
    }
}
