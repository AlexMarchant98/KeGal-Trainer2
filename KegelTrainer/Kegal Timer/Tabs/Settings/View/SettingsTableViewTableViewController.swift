//
//  SettingsTableViewTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork
import MessageUI
import MaterialComponents.MaterialTextFields

class SettingsTableViewController : UITableViewController, GADBannerViewDelegate, Storyboarded {
    
    let notificationCenter = NotificationCenter.default
    var iapAdRemovalPurchaseNotificationObserver: NSObjectProtocol?
    var iapErrorNotificationObserver: NSObjectProtocol?
    
    var settingsPresenter: SettingsPresenterProtocol!
    
    var adServer: AdServer!
    
    var adBannerView: GADBannerView!
    var audienceNetworkBannerView: FBAdView!
    
    var dirtyInput = false
    
    @IBOutlet weak var repsPerSetTextBox: MDCTextField!
    @IBOutlet weak var repLengthTextBox: MDCTextField!
    @IBOutlet weak var restLengthTextBox: MDCTextField!
    
    var repsPerSetTextBoxController: MDCTextInputControllerOutlined!
    var repLengthTextBoxController: MDCTextInputControllerOutlined!
    var restLengthTextBoxController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var vibrateCueSwitch: UISwitch!
    @IBOutlet weak var visualCueSwitch: UISwitch!
    @IBOutlet weak var soundCueSwitch: UISwitch!
    
    var loadingView: LoadingView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        settingsPresenter.getSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        self.view.backgroundColor = .workoutBackgroundColor
        self.tableView.backgroundColor = .workoutBackgroundColor
        self.tableView.separatorColor = .leaderboardGray
        self.tableView.sectionIndexColor = .white
        
        navigationItem.setLeftBarButton(nil, animated: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restore Purchases", style: .plain, target: self, action: #selector(restorePurchases))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
        
        vibrateCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        visualCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        soundCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        
        setupAdvertArea()
        setupTabBarDelegate()
        setupTextFields()
        registerForNotifications()
        
        loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.view.addSubview(loadingView)
    }
    
    func setLoading(isLoading: Bool) {
        loadingView.setLoading(isLoading: isLoading)
    }
    
    @objc private func switchStateChanged(switch: UISwitch)
    {
        dirtyInput = true
    }
    
    @objc func saveChanges()
    {
        setLoading(isLoading: true)
        
        settingsPresenter.saveSettings(
                repsPerSet: repsPerSetTextBox.text,
                repLength: repLengthTextBox.text,
                restLength: restLengthTextBox.text,
                vibrateCueIsOn: vibrateCueSwitch.isOn,
                visualCueIsOn: visualCueSwitch.isOn,
                soundCueIsOn: soundCueSwitch.isOn)
    }
    
    @objc func restorePurchases() {
        
        settingsPresenter.restoreIAPPurchases()
        
        let saveSuccessfulAlert = UIAlertController(title: "Purchases Successfully Restored", message: "Please re-open the app for the restore to take effect!", preferredStyle: UIAlertController.Style.alert)
        
        saveSuccessfulAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in saveSuccessfulAlert.dismiss(animated: true, completion: nil); self.tableView.reloadData()}))
        
        self.present(saveSuccessfulAlert, animated: true, completion: nil)
    }
    
    func showEmail() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            
            vc.mailComposeDelegate = self
            
            vc.setToRecipients([Constants.supportEmail])
            
            self.present(vc, animated: true, completion: nil)
        } else {
            AlertHandlerService.shared.showWarningAlert(
                view: self,
                message: "In order to send an email through the app, you must first connect an email to the mail app. \n \n Support Email: \n \(Constants.supportEmail)")
        }
    }
    
}

extension SettingsTableViewController: SettingsPresenterView {
    
    func didGetSettings(repsPerSet: Int, repLength: Int, restLength: Int, vibrateCueIsOn: Bool, visualCueIsOn: Bool, soundCueIsOn: Bool) {
        
        repsPerSetTextBox.text = "\(repsPerSet)"
        repLengthTextBox.text = "\(repLength)"
        restLengthTextBox.text = "\(restLength)"
        
        vibrateCueSwitch.isOn = vibrateCueIsOn
        visualCueSwitch.isOn = visualCueIsOn
        soundCueSwitch.isOn = soundCueIsOn
        
        dirtyInput = false
        setLoading(isLoading: false)
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
        
        setLoading(isLoading: false)
    }
    
    func settingsSaved() {
        
        dirtyInput = false
        setLoading(isLoading: false)
        
        AlertHandlerService.shared.showCustomAlert(
            view: self,
            title: "Settings Saved",
            message: "Your updated settings have been saved.",
            actionTitles: ["Ok"],
            actions: [
                { (action: UIAlertAction!) in print("Do nothing") }
            ]
        )
    }
    
    
    func didLoadIAPInformation(title: String, description: String, localPrice: String) {
        AlertHandlerService.shared.showCustomAlert(
            view: self,
            title: "\(title) for \(localPrice)",
            message: description,
            actionTitles: ["Cancel", "Purchase"],
            actions: [
                { (action: UIAlertAction!) in
                    self.setLoading(isLoading: false)
                },
                { (action: UIAlertAction!) in self.settingsPresenter.purchaseAdRemoval()
                }
            ]
        )
    }
    
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SettingsTableViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        dirtyInput = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
        dirtyInput = true
        return true
    }
}
