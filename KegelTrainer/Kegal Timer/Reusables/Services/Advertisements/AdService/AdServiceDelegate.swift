//
//  AdServiceDelegate.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 25/02/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol AdServiceDelegate {
    func didFailToLoadBanner(_ adService: AdService)
    func didFailToLoadInterstitial(_ adService: AdService)
}
