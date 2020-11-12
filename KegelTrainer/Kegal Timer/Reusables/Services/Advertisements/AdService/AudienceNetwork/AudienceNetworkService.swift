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
    
    let delegate: AdServiceDelegate
    
    var interstitialAd: FBInterstitialAd!
    
    init(delegate: AdServiceDelegate) {
        
        self.delegate = delegate
        
        self.interstitialAd = FBInterstitialAd(placementID: Constants.audienceNetworkWorkoutCompletePlacementId)
        
        super.init()
        
        self.interstitialAd.delegate = self
        
        loadAds()
    }
    
    func loadAds() {
        self.interstitialAd.load()
    }
    
    func setupAdBannerView(
        _ placementId: String,
        _ viewController: UIViewController,
        _ bannerContainerView: UIView) -> FBAdView {
        
        let bannerView = FBAdView(
            placementID: placementId,
            adSize: kFBAdSizeHeight50Banner,
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
        
        self.delegate.didFailToLoadInterstitial(AdService.audienceNetwork)
    }
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        loadAds()
    }
}

extension AudienceNetworkService: FBAdViewDelegate {
    func adViewDidLoad(_ adView: FBAdView) {
        print("-----AUDIENCE NETWORK BANNER-----")
        print("Banner loaded successfully")

        if (adView.isAdValid) {
            // Reposition the banner ad to create a slide down effect
            let translateTransform = CGAffineTransform(translationX: 0, y: -adView.bounds.size.height)
            adView.transform = translateTransform

            UIView.animate(withDuration: 0.5) {
                adView.transform = CGAffineTransform.identity
                adView.centerInSuperview()
                adView.superview?.setNeedsLayout()
            }
        } else {
            print("-----AUDIENCE NETWORK BANNER-----")
            print("Banner ad was not valid")
        }
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("-----AUDIENCE NETWORK BANNER-----")
        print("Banner failed to load with the following error: \(error)")
        
        self.delegate.didFailToLoadBanner(AdService.audienceNetwork)
    }
}
