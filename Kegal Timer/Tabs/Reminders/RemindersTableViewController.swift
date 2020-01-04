//
//  RemindersTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 03/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds
import FBAudienceNetwork

protocol RemindersTableViewControllerDelegate: AnyObject {
    func didTapAddReminder()
    func didTapUpdateReminder(_ reminder: Reminder)
}

class RemindersTableViewController: UITableViewController, GADBannerViewDelegate, Storyboarded {
    
    public weak var delegate: RemindersTableViewControllerDelegate?
    
    internal var alertHandlerService = AlertHandlerService()
    
    var adServer: AdServer!
    
    var reminders = [Reminder]()
    
    var adMobBannerView: GADBannerView!
    var audienceNetworkBannerView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminders"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addReminder))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.remindersTableViewCellReuseIdentifier)
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        
        if let returnedAdMobBannerView = self.adServer.setupAdMobBannerView(
            adId: Constants.remindersTabBannerAdId,
            viewController: self,
            bannerContainerView: self.tableView!.tableHeaderView!) {
            
            self.adMobBannerView = returnedAdMobBannerView
        } else {
            if let returnedAudienceNetworkBannerView = self.adServer.setupAudienceNetworkBannerView(
                placementId: Constants.audienceNetworkTabsBannerAdPlacementId,
                viewController: self,
                bannerContainerView: self.tableView!.tableHeaderView!) {
                
                self.audienceNetworkBannerView = returnedAudienceNetworkBannerView
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        areNotificationsEnabled(callback: { (isEnabled) in
            if(!isEnabled) {
                self.alertHandlerService.showCustomAlert(
                    view: self,
                    title: "Notification are disabled",
                    message: "To setup reminders, please enable notifications for Kegel Trainer.",
                    actionTitles: ["OK"],
                    actions: [ { (action: UIAlertAction!) in
                            self.navigationController?.tabBarController?.selectedIndex = 1 }
                ])
            }
        })
        
        generateReminders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reminders"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row < self.reminders.count) {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.reminders.count <= 5)
        {
            return 5
        } else {
            return self.reminders.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.remindersTableViewCellReuseIdentifier, for: indexPath)
        var text = ""
        var detailText = ""
        
        reminders.sort(by: { $0.Time.stripDate() < $1.Time.stripDate() })
        
        if(indexPath.row < reminders.count) {
            let reminder = reminders[indexPath.row]
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            text = formatter.string(from: reminder.Time)
            detailText = reminder.Message
        }
        
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteReminder(row: indexPath.row)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < reminders.count) {
            self.delegate?.didTapUpdateReminder(reminders[indexPath.row])
        }
    }
    
    func generateReminders()
    {
        reminders.removeAll()
        
        let center = UNUserNotificationCenter.current()
        let dq = DispatchQueue.global(qos: .userInteractive)
        dq.async {
            center.getPendingNotificationRequests { (notifications) in
                for item in notifications {
                    if let trigger = item.trigger as? UNCalendarNotificationTrigger,
                        let triggerDate = trigger.nextTriggerDate() {
                        var withSound = true
                        if(item.content.sound != UNNotificationSound.default)
                        {
                            withSound = false
                        }
                        self.reminders.append(Reminder(identifier: item.identifier, time: triggerDate, message: item.content.body, withSound: withSound, isAPendingNotification: true))
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addReminder()
    {
        self.delegate?.didTapAddReminder()
    }
    
    func deleteReminder(row: Int)
    {
        let center = UNUserNotificationCenter.current()
        let reminder = reminders[row]
        
        switch(reminder.IsAPendingNotification) {
            case true:
                center.removePendingNotificationRequests(withIdentifiers: [reminder.Identifier])
            default:
                center.removeDeliveredNotifications(withIdentifiers: [reminder.Identifier])
        }
        
        reminders.remove(at: row)
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
    
    func areNotificationsEnabled(callback: @escaping(Bool) -> Void)
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            if(settings.authorizationStatus != .authorized) {
                callback(false)
            } else {
                callback(true)
            }
        }
    }
}
