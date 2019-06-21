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
    
    private static let productIdentifiers: Set<ProductIdentifier> = [IAPProducts.MidTierAdRemoval]
    
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
