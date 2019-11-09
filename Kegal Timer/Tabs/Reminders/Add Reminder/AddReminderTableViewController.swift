//
//  RemindersTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddReminderTableViewControllerDelegate: AnyObject {
    func didAddReminder(_ addReminderTableViewController: AddReminderTableViewController)
}

class AddReminderTableViewController: UITableViewController, Storyboarded {
    
    public weak var delegate: AddReminderTableViewControllerDelegate?
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageTextField: UITextField!
    @IBOutlet weak var reminderSoundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Reminder"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addReminder))
    }
    
    @objc func addReminder()
    {
        scheduleNotification()
        
        self.delegate?.didAddReminder(self)
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Workout Time!"
        content.body = reminderMessageTextField.text ?? "Lets get this workout done!"
        
        if(reminderSoundSwitch.isOn) {
            content.sound = UNNotificationSound.default
        }
        
        let selectedTime = reminderDatePicker.date
        let triggerTime = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        
        let request = UNNotificationRequest(identifier: "KegalTimer\(triggerTime)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}
