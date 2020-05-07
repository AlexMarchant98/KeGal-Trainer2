//
//  AdServerNotifications.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 25/02/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didFailToLoadAdMobBanner = Notification.Name("didFailToLoadAdMobBanner")
    static let didFailToLoadAdMobInterstitial = Notification.Name("didFailToLoadAdMobInterstitial")
    static let didFailToLoadAudienceNetworkBanner = Notification.Name("didFailToLoadAudienceNetworkBanner")
    static let didFailToLoadAudienceNetworkInterstitial = Notification.Name("didFailToLoadAudienceNetworkInterstitial")
}

extension Notification {
    static func didFailToLoadAdMobBanner() -> Notification {
        return Notification(name: Notification.Name.didFailToLoadAdMobBanner)
    }
    static func didFailToLoadAdMobInterstitial() -> Notification {
        return Notification(name: Notification.Name.didFailToLoadAdMobInterstitial)
    }
    static func didFailToLoadAudienceNetworkBanner() -> Notification {
        return Notification(name: Notification.Name.didFailToLoadAudienceNetworkBanner)
    }
    static func didFailToLoadAudienceNetworkInterstitial() -> Notification {
        return Notification(name: Notification.Name.didFailToLoadAudienceNetworkInterstitial)
    }
}
