//
//  SettingsTableViewTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit
import MessageUI

class SettingsTableViewController : UITableViewController, UITabBarControllerDelegate, GADBannerViewDelegate, Storyboarded {
    
    weak var coordinator: SettingsCoordinator?
    internal var alertHandlerService = AlertHandlerService()
    
    let adMobDisplayer = AdMobDisplayer()
    let userPreferences = UserDefaults.standard
    
    var adBannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    var products: [SKProduct] = []
    
    var dirtyInput = false
    
    @IBOutlet weak var repsPerSetTextBox: UITextField!
    @IBOutlet weak var repLengthTextBox: UITextField!
    @IBOutlet weak var restLengthTextBox: UITextField!
    
    @IBOutlet weak var vibrateCueSwitch: UISwitch!
    @IBOutlet weak var visualCueSwitch: UISwitch!
    @IBOutlet weak var soundCueSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        repsPerSetTextBox.text = String(userPreferences.integer(forKey: Constants.repsPerSet))
        repLengthTextBox.text = String(userPreferences.integer(forKey: Constants.repLength))
        restLengthTextBox.text = String(userPreferences.integer(forKey: Constants.restLength))
        
        vibrateCueSwitch.isOn = userPreferences.bool(forKey: Constants.vibrationCue)
        visualCueSwitch.isOn = userPreferences.bool(forKey: Constants.visualCue)
        soundCueSwitch.isOn = userPreferences.bool(forKey: Constants.soundCue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        navigationItem.setLeftBarButton(nil, animated: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restore Purchases", style: .plain, target: self, action: #selector(restorePurchases))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
        
        self.tabBarController?.delegate = self
        
        repsPerSetTextBox.delegate = self
        repLengthTextBox.delegate = self
        restLengthTextBox.delegate = self
        
        vibrateCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        visualCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        soundCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        
        self.hideKeyboardWhenTappedAround()
        
        self.adBannerView = self.adMobDisplayer.setupAdBannerView(self.adBannerView, viewController: self, adUnitId: Constants.settingsTabBannerAdId, bannerViewDelgate: self)
        
        self.adMobDisplayer.displayBannerAd(self.adBannerView)
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            
            self.products = []
            
            IAPProducts.store.requestProducts{ [weak self] success, products in
                guard let self = self else { print("Products not found"); return }
                if success {
                    print("Products loaded successfully")
                    self.products = products!
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Products loaded unsuccessfully")
                }
                
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        
        self.tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.section == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
                if(products.count != 0) {
                    let product = products[indexPath.row]
                    
                    cell.product = product
                    cell.buyButtonHandler = { product in
                        IAPProducts.store.buyProduct(product)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emailIndexPath = IndexPath(row: 0, section: 2)
        
        switch indexPath {
        case emailIndexPath:
            if MFMailComposeViewController.canSendMail() {
                let vc = MFMailComposeViewController()
                
                vc.mailComposeDelegate = self
                
                vc.setToRecipients(["alex_marchant@outlook.com"])
                
                self.present(vc, animated: true, completion: nil)
            } else {
                alertHandlerService.showWarningAlert(
                    view: self,
                    message: "In order to send an email through the app, you must first connect an email to the mail app. \n \n My Email: \n alex_marchant@outlook.com")
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setWorkoutSettings(repsPerSet: Int, repLength: Int, restLength: Int) {
        dirtyInput = true
        
        repsPerSetTextBox.text = String(repsPerSet)
        repLengthTextBox.text = String(repLength)
        restLengthTextBox.text = String(restLength)
    }
    
    @objc private func switchStateChanged(switch: UISwitch)
    {
        dirtyInput = true
    }
    
    @objc func saveChanges()
    {
        if (!checkValuesAreValid())
        {
            let invalidInputAlert = UIAlertController(title: "Invalid Inputs", message: "Please enter valid values for all inputs", preferredStyle: UIAlertController.Style.alert)
            
            invalidInputAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in invalidInputAlert.dismiss(animated: true, completion: nil)}))
            
            self.present(invalidInputAlert, animated: true, completion: nil)
        } else {
            dirtyInput = false
            
            saveSettings()
            
            let saveSuccessfulAlert = UIAlertController(title: "Save Successful", message: "", preferredStyle: coordinator?.getAlertStyle() ?? UIAlertController.Style.alert)
            
            saveSuccessfulAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in saveSuccessfulAlert.dismiss(animated: true, completion: nil)}))
            
            self.present(saveSuccessfulAlert, animated: true, completion: nil)
        }
    }
    
    private func checkValuesAreValid() -> Bool
    {
        if(repsPerSetTextBox.text!.isEmpty || repsPerSetTextBox.text!.first == "0")
        {
            return false
        }
        else if(repLengthTextBox.text!.isEmpty || repLengthTextBox.text!.first == "0")
        {
            return false
        }
        else if(restLengthTextBox.text!.isEmpty || restLengthTextBox.text!.first == "0")
        {
            return false
        }
        
        return true
    }
    
    private func saveSettings()
    {
        userPreferences.set(Int(repsPerSetTextBox.text!), forKey: Constants.repsPerSet)
        userPreferences.set(Int(repLengthTextBox.text!), forKey: Constants.repLength)
        userPreferences.set(Int(restLengthTextBox.text!), forKey: Constants.restLength)
        
        /// Since the user is editing the workout values, invalidate current level
        userPreferences.set(0, forKey: Constants.stage)
        userPreferences.set("", forKey: Constants.level)
        userPreferences.set(0, forKey: Constants.levelOrder)
        
        userPreferences.set(vibrateCueSwitch.isOn, forKey: Constants.vibrationCue)
        userPreferences.set(visualCueSwitch.isOn, forKey: Constants.visualCue)
        userPreferences.set(soundCueSwitch.isOn, forKey: Constants.soundCue)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(dirtyInput) {
            let unsavedChangesAlert = UIAlertController(title: "Unsaved changes", message: "You have unsaved changes, are you sure you want to navigate away?", preferredStyle: UIAlertController.Style.actionSheet)
            
            unsavedChangesAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (_) in self.dirtyInput = false; tabBarController.selectedViewController = viewController }))
            unsavedChangesAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive))
            
            self.present(unsavedChangesAlert, animated: true, completion: nil)

            return false
        } else {
            return true
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    @objc func restorePurchases() {
        
        IAPProducts.store.restorePurchases()
        
        let saveSuccessfulAlert = UIAlertController(title: "Purchases Successfully Restored", message: "Please re-open the app for the restore to take effect!", preferredStyle: UIAlertController.Style.alert)
        
        saveSuccessfulAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in saveSuccessfulAlert.dismiss(animated: true, completion: nil); self.tableView.reloadData()}))
        
        self.present(saveSuccessfulAlert, animated: true, completion: nil)
    }
    
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
