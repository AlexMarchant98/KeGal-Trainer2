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
    
    let delegate: AdServiceDelegate
    
    var interstitial: GADInterstitial!
    var bannerAdRequest: GADRequest!
    var interstitialAdRequest: GADRequest!
    
    var bannerContainerView: UIView!
    
    init(delegate: AdServiceDelegate) {
        
        self.delegate = delegate
        
        self.bannerAdRequest = GADRequest()
        self.interstitialAdRequest = GADRequest()
        
        self.interstitial = GADInterstitial(adUnitID: Constants.generalInterstitialAdId)
        
        super.init()
        
        self.interstitial.delegate = self
        
        loadAds()
    }
    
    func loadAds() {
        self.interstitialAdRequest = GADRequest()
        self.interstitial = GADInterstitial(adUnitID: Constants.generalInterstitialAdId)
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
        _ adUnitId: String,
        _ viewController: UIViewController,
        _ bannerContainerView: UIView) -> GADBannerView {
        
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = Constants.generalBannerAdId
        bannerView.rootViewController = viewController
        bannerView.delegate = self
        
        bannerView.load(self.bannerAdRequest)
        
        bannerContainerView.addSubview(bannerView)
        
        return bannerView
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
        
        self.delegate.didFailToLoadInterstitial(AdService.adMob)
        
        loadAds()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        loadAds()
    }
}

extension AdMobService: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("-----ADMOB BANNER-----")
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
            bannerView.centerInSuperview()
            bannerView.superview?.setNeedsLayout()
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("-----ADMOB BANNER-----")
        print("Banner failed to load with the following error: \(error.localizedDescription)")
        
        self.delegate.didFailToLoadBanner(AdService.adMob)
    }
}
