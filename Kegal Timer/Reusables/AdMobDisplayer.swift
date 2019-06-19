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
    
    func setupGadInterstitial(adUnitID: String) {
        self.interstitial = GADInterstitial(adUnitID: adUnitID)
        let request = GADRequest()
        self.interstitial!.load(request)
    }
    
    func displayGADInterstitial(viewController: UIViewController) {
        if self.interstitial?.isReady ?? false {
            self.interstitial!.present(fromRootViewController: viewController)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func setupAdBannerView(_ bannerView: GADBannerView, viewController: UIViewController, adUnitId: String, bannerViewDelgate: GADBannerViewDelegate? = nil) -> GADBannerView {
        /// bannerView.adUnitID = adUnitId
        bannerView.adUnitID = Constants.testBannerAdId
        bannerView.rootViewController = viewController
        
        if let delegate = bannerViewDelgate {
            bannerView.delegate = delegate
        }
        
        return bannerView
    }
    
    func displayBannerAd(_ bannerView: GADBannerView) {
        let request = GADRequest()
        bannerView.load(request)
    }
}
