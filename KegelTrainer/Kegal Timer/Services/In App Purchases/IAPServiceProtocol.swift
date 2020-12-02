//
//  IAPServiceProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPServiceProtocol {
    func getLoadedIAPProduct(with id: String) -> SKProduct?
    func purchaseAdRemoval()
    func purchaseStreakSaver()
    func purchaseStreakProtector()
    func restoreIAPPurchases()
}
