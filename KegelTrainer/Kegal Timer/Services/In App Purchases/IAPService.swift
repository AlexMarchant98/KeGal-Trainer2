//
//  IAPService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject, IAPServiceProtocol {
    
    private (set) var purchasedIAPProducts = [String]()
    private (set) var loadedIAPProducts = [SKProduct]()
    
    private var isAttemptingToPurchase: Bool = false
    private var currentProductId: String?
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        
        loadAllIAPs()
        restorePurchases()
    }
    
    func getLoadedIAPProduct(with id: String) -> SKProduct? {
        return loadedIAPProducts.first(where: { $0.productIdentifier == id })
    }
    
    func purchaseAdRemoval() {
        purchaseIAP(productId: IAPProducts.MidTierAdRemoval)
    }
    
    func purchaseStreakSaver() {
        purchaseIAP(productId: IAPProducts.saveLostStreak)
    }
    
    func purchaseStreakProtector() {
        purchaseIAP(productId: IAPProducts.streakProtector)
    }
    
    func restoreIAPPurchases() {
        restorePurchases()
    }
    
    func purchaseIAP(productId: String) {
        
        if(purchasedIAPProducts.contains(productId)) {
            
            let iapNotification = IAPNotification(
                successful: true,
                message: "You have already purchased this product, please restart the app if it has not taken affect.",
                productId: "")
            
            if(productId == IAPProducts.MidTierAdRemoval) {
                UserDefaults.standard.set(true, forKey: Constants.adsDisabled)
            }
            
            deliverPurchaseNotificationFor(iapNotification: iapNotification)
            
            return
        }
        
        isAttemptingToPurchase = true
        
        if let product = getLoadedProduct(productId: productId) {
            purchaseIAP(product: product)
        } else {
            getIAP(productId: productId)
        }
        
    }
    
    func getLoadedProduct(productId: String) -> SKProduct? {
        return loadedIAPProducts.first(where: { $0.productIdentifier == productId })
    }
    
    func loadAllIAPs() {
        
        print("About to fetch the products")
        
        if (SKPaymentQueue.canMakePayments())
        {
            let productsRequest = SKProductsRequest(productIdentifiers: IAPProducts.allProductIdentifiers)
            
            productsRequest.delegate = self
            productsRequest.start()
            
            print("Fetching All Products")
        } else {
            print("Can not make purchases")
        }
        
    }
    
    func getIAP(productId: String) {
        
        print("About to fetch the products")
        
        if (SKPaymentQueue.canMakePayments())
        {
            self.currentProductId = productId
            
            let productIdSet = Set<String>(arrayLiteral: productId)
            let productsRequest = SKProductsRequest(productIdentifiers: productIdSet)
            
            productsRequest.delegate = self
            productsRequest.start()
            
            print("Fetching Product")
        } else {
            print("Can not make purchases")
        }
    }
    
    private func purchaseIAP(product: SKProduct) {
        
        print("Sending the Payment Request to Apple")
        
        let payment = SKPayment(product: product)
        
        SKPaymentQueue.default().add(payment);
    }
    
    func restorePurchases() {
        
        let purchasedAdRemoval = UserDefaults.standard.bool(forKey: Constants.adsDisabled)
        
        if purchasedAdRemoval {
            purchasedIAPProducts.append(IAPProducts.MidTierAdRemoval)
        } else {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
}

// MARK: - StoreKit API

extension IAPService: SKProductsRequestDelegate {
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        
        self.currentProductId = nil
        self.isAttemptingToPurchase = false
        
        let iapNotification = IAPNotification(
            successful: false,
            message: "Something went wrong whilst loading the app's In-App Purchases, please try again.",
            productId: "")
        
        deliverPurchaseNotificationFor(iapNotification: iapNotification)
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Products loaded from Apple")
        
        if (response.products.count > 0) {
            
            for product in response.products {
                
                let productAlreadyLoaded = loadedIAPProducts.contains(where: { $0.productIdentifier == product.productIdentifier })
                    
                if(productAlreadyLoaded == false) {
                    self.loadedIAPProducts.append(product)
                }
                
                if(isAttemptingToPurchase) {
                    if (product.productIdentifier == self.currentProductId) {
                        purchaseIAP(product: product)
                    }
                }
            }
        } else {
            print("No products were loaded")
        }
    }
    
}

// MARK: - SKPaymentTransactionObserver

extension IAPService: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("Received Payment Transaction Response from Apple");
        
        self.currentProductId = nil
        self.isAttemptingToPurchase = false

        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                
                print("Product Purchased")
                complete(transaction: transaction)
                
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                
            case .failed:
                
                print("Purchased Failed")
                fail(transaction: transaction)
                
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                
            case .restored:
                
                print("Purchase Restored")
                restore(transaction: transaction)
                
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                
            case .deferred:
            
                print("Awaiting")
            
            case .purchasing:
            
                print("Being purchased as we speak")
                
            default:
                
                print("Unknown state")
                
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Completed the transaction")
        
        // Ad Removal is non-consumable so we don't want the user buying another
        if(transaction.payment.productIdentifier == IAPProducts.MidTierAdRemoval) {
            self.purchasedIAPProducts.append(IAPProducts.MidTierAdRemoval)
        }
        
        let iapNotification = IAPNotification(
            successful: true,
            message: "Your purchase was successful!",
            productId: transaction.payment.productIdentifier)
        
        deliverPurchaseNotificationFor(iapNotification: iapNotification)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        if(productIdentifier == IAPProducts.MidTierAdRemoval) {
            UserDefaults.standard.set(true, forKey: Constants.adsDisabled)
        }
        
        print("Restoring \(productIdentifier)")
        
        let iapNotification = IAPNotification(
            successful: true,
            message: "Your previous purchases have been restored, you might have to restart the app for it to take affect.",
            productId: transaction.payment.productIdentifier)
        
        deliverPurchaseNotificationFor(iapNotification: iapNotification)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        
        print("Transaction failed")
        
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        let iapNotification = IAPNotification(
            successful: false,
            message: "Something went wrong whilst purchasing that product, please try again. \n\n Please note you have not been charged.",
            productId: transaction.payment.productIdentifier)
        
        deliverPurchaseNotificationFor(iapNotification: iapNotification)
    }
    
    private func deliverPurchaseNotificationFor(iapNotification: IAPNotification) {
        
        let notificationDataDict:[String: IAPNotification] = [Constants.iapNotificationUserInfoKey: iapNotification]
        
        switch iapNotification.productId {
        case IAPProducts.MidTierAdRemoval:
            NotificationCenter.default.post(
                name: .iapAdRemovalPurchaseNotification,
                object: nil,
                userInfo: notificationDataDict)
            break
            
        case IAPProducts.streakProtector:
            NotificationCenter.default.post(
                name: .iapStreakProtectorPurchaseNotification,
                object: nil,
                userInfo: notificationDataDict)
            break
        
        case IAPProducts.saveLostStreak:
            NotificationCenter.default.post(
                name: .iapSaveStreakPurchaseNotification,
                object: nil,
                userInfo: notificationDataDict)
            break
            
        default:
            NotificationCenter.default.post(
                name: .iapErrorNotification,
                object: nil,
                userInfo: notificationDataDict)
            break
        }
    }
}
