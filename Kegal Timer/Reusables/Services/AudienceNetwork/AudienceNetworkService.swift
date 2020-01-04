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
    var bannerAd: FBAdView!
    
    var areAdsDisabled: Bool!
    
    override init() {
        super.init()
        
        self.areAdsDisabled = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        self.interstitialAd = FBInterstitialAd(placementID: Constants.audienceNetworkWorkoutCompletePlacementId)
        
        self.interstitialAd.delegate = self
        self.interstitialAd.load()
    }
    
    func displayAudienceNetworkInterstitial(viewController: UIViewController) {
        if(!areAdsDisabled) {
            if self.interstitialAd.isAdValid {
                self.interstitialAd.show(fromRootViewController: viewController)
            } else {
                print("Audience Network interstitial Ad wasn't ready")
            }
        }
    }
    
}

extension AudienceNetworkService: FBInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Audience Network interstitial ad loaded")
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("Audience Network interstitial ad failed to load with the following error: \(error.localizedDescription)")
    }
}
