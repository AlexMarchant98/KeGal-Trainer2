//
//  AdMobDisplayer.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 15/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMobService: NSObject {
    
    var interstitial: GADInterstitial!
    var bannerAdRequest: GADRequest!
    var interstitialAdRequest: GADRequest!
    
    override init() {
        super.init()
        
        self.bannerAdRequest = GADRequest()
        self.interstitialAdRequest = GADRequest()
        
        self.interstitial = GADInterstitial(adUnitID: Constants.workoutCompleteAdId)
        self.interstitial.delegate = self
        
        loadAds()
    }
    
    func loadAds() {
        self.interstitial.load(self.interstitialAdRequest)
    }
    
    func displayGADInterstitial(_ viewController: UIViewController) -> Bool {
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: viewController)
            return true
        } else {
            print("AdMob interstitial Ad wasn't ready")
            return false
        }
    }
    
    func setupAdBannerView(
        _ bannerView: GADBannerView,
        _ viewController: UIViewController,
        _ adUnitId: String,
        _ bannerViewDelgate: GADBannerViewDelegate? = nil) -> GADBannerView {
        
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = viewController
        
        if let delegate = bannerViewDelgate {
            bannerView.delegate = delegate
        }
        
        return bannerView
    }
    
    func displayBannerAd(_ bannerView: GADBannerView) {
        bannerView.load(self.bannerAdRequest)
    }
}

extension AdMobService: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("-----ADMOB INTERSTITIAL-----")
        print("AdMob interstitial ad loaded")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("-----ADMOB INTERSTITIAL-----")
        print("AdMob interstitial failed to load with error: \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        loadAds()
    }
}
