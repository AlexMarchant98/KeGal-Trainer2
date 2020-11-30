//
//  IAPProducts.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 21/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation

public struct IAPProducts {
    
    public static let MidTierAdRemoval = "KegalTimer.MidTierAdRemoval"
    public static let streakProtector = "KTSPSINGLE"
    public static let saveLostStreak = "KTSLSTREAK"
    
    public static let allProductIdentifiers: Set<ProductIdentifier> = [IAPProducts.MidTierAdRemoval, IAPProducts.streakProtector, IAPProducts.saveLostStreak]
    
    public static let store = IAPHelper(productIds: IAPProducts.allProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
