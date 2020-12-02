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
    
    private (set) var areAdsDisabled: Bool!
    let notificationCenter = NotificationCenter.default
    
    var adMobService: AdMobService!
    var audienceNetworkService: AudienceNetworkService!
    
    var iapAdRemovalPurchaseNotificationObserver: NSObjectProtocol?
    
    init() {
        self.areAdsDisabled = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        self.adMobService = AdMobService(delegate: self)
        self.audienceNetworkService = AudienceNetworkService(delegate: self)
        
        registerForNotifications()
    }
    
    deinit {
        deregisterNotifications()
    }
    
    func registerForNotifications() {
        
        iapAdRemovalPurchaseNotificationObserver = notificationCenter
            .addObserver(forName: .iapAdRemovalPurchaseNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if let iapNotification = notification.userInfo?[Constants.iapNotificationUserInfoKey] as? IAPNotification {
                    
                    if(iapNotification.successful) {
                        self.areAdsDisabled = true
                    }
                }
            }
        
    }
    
    private func deregisterNotifications() {
        if let iapAdRemovalPurchaseNotificationObserver = self.iapAdRemovalPurchaseNotificationObserver {
            notificationCenter.removeObserver(iapAdRemovalPurchaseNotificationObserver, name: .iapAdRemovalPurchaseNotification, object: nil)
        }
    }
    
    func reloadAds() {
        if(!areAdsDisabled) {
            self.adMobService.loadAds()
            self.audienceNetworkService.loadAds()
        }
    }
    
    func displayInterstitialAd(viewController: UIViewController, userWantsToViewAd: Bool = false) {
        if(areAdsDisabled == false || userWantsToViewAd == true) {
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

extension AdServer: AdServiceDelegate {
    
    func didFailToLoadBanner(_ adService: AdService) {
        switch adService {
        case .adMob:
            self.notificationCenter.post(.didFailToLoadAdMobBanner())
        case .audienceNetwork:
            self.notificationCenter.post(.didFailToLoadAudienceNetworkBanner())
        }
    }
    
    func didFailToLoadInterstitial(_ adService: AdService) {
        switch adService {
        case .adMob:
            self.notificationCenter.post(.didFailToLoadAdMobInterstitial())
        case .audienceNetwork:
            self.notificationCenter.post(.didFailToLoadAudienceNetworkInterstitial())
        }
    }
    
    func didDismissInterstitial(_ adService: AdService) {
        switch adService {
        case .adMob:
            self.notificationCenter.post(.didDismissInterstitial())
        case .audienceNetwork:
            self.notificationCenter.post(.didDismissInterstitial())
        }
    }
    
}
