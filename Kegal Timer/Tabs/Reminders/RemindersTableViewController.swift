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

class RemindersTableViewController: UITableViewController, GADBannerViewDelegate, Storyboarded {
    
    weak var coordinator: RemindersCoordinator?
    let adMobDisplayer = AdMobDisplayer()
    
    var reminders = [Reminder]()
    var selectedReminder: Reminder?
    
    var adBannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminders"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addReminder))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.remindersTableViewCellReuseIdentifier)
        
        self.adBannerView = self.adMobDisplayer.setupAdBannerView(self.adBannerView, viewController: self, adUnitId: Constants.remindersTabBannerAdId, bannerViewDelgate: self)
        
        self.adMobDisplayer.displayBannerAd(self.adBannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.checkNotificationSettings()
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
            selectedReminder = reminders[indexPath.row]
            coordinator?.showUpdateReminder(reminder: selectedReminder!)
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
        coordinator?.showAddReminder()
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
}
