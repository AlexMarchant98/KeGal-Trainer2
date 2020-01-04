//
//  AudienceNetworkService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/01/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FBAudienceNetwork

class AudienceNetworkService: NSObject {
    
    var interstitialAd: FBInterstitialAd!
    
    override init() {
        super.init()
        
        self.interstitialAd = FBInterstitialAd(placementID: Constants.audienceNetworkWorkoutCompletePlacementId)
        
        self.interstitialAd.delegate = self
        
        loadAds()
    }
    
    func loadAds() {
        self.interstitialAd.load()
    }
    
    func setupAdBannerView(
        _ placementId: String,
        _ adSize: CGSize,
        _ viewController: UIViewController,
        _ bannerContainerView: UIView) -> FBAdView {
        
        let bannerView = FBAdView(
            placementID: placementId,
            adSize: FBAdSize(size: adSize),
            rootViewController: viewController)
        
        bannerView.delegate = self
        
        bannerView.loadAd()
        
        bannerContainerView.addSubview(bannerView)
        
        return bannerView
    }
    
    func displayAudienceNetworkInterstitial(_ viewController: UIViewController) {
        if self.interstitialAd.isAdValid {
            self.interstitialAd.show(fromRootViewController: viewController)
        } else {
            print("Audience Network interstitial Ad wasn't ready")
        }
    }
    
}

extension AudienceNetworkService: FBInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("-----AUDIENCE NETWORK INTERSTITIAL-----")
        print("Audience Network interstitial ad loaded")
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("-----AUDIENCE NETWORK INTERSTITIAL-----")
        print("Audience Network interstitial ad failed to load with the following error: \(error.localizedDescription)")
    }
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        loadAds()
    }
}

extension AudienceNetworkService: FBAdViewDelegate {
    func adViewDidLoad(_ adView: FBAdView) {
        print("-----AUDIENCE NETWORK BANNER-----")
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -adView.bounds.size.height)
        adView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            adView.transform = CGAffineTransform.identity
            adView.centerInSuperview()
            adView.superview?.setNeedsLayout()
        }
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("-----AUDIENCE NETWORK BANNER-----")
        print("Banner failed to load with the follow error: \(error.localizedDescription)")
    }
}
