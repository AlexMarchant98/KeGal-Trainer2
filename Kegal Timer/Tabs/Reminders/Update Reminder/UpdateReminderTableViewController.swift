//
//  UpdateReminderTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications

protocol UpdateReminderTableViewControllerDelegate: AnyObject {
    func didFinishUpdatingReminder(_ updateReminderTableViewController: UpdateReminderTableViewController)
}

class UpdateReminderTableViewController: UITableViewController, Storyboarded {
    
    public weak var delegate: UpdateReminderTableViewControllerDelegate?
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageTextField: UITextField!
    @IBOutlet weak var reminderSoundSwitch: UISwitch!
    
    var reminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Update Reminder"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateReminder))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderDatePicker.setDate((reminder?.Time)!, animated: true)
        reminderMessageTextField.text = reminder?.Message
        reminderSoundSwitch.isOn = (reminder?.WithSound)!
    }
    
    @objc func updateReminder()
    {
        rescheduleNotification()
        
        self.delegate?.didFinishUpdatingReminder(self)
    }
    
    func rescheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Workout Time!"
        content.body = reminderMessageTextField.text ?? "Lets get this workout done!"
        
        if(reminderSoundSwitch.isOn) {
            content.sound = UNNotificationSound.default
        }
        
        let selectedTime = reminderDatePicker.date
        let triggerTime = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        
        if let identifier = reminder?.Identifier {
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            print("Inconsistency with notification identifiers")
        }
    }

}
