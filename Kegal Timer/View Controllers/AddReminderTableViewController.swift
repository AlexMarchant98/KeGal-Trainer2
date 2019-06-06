//
//  RemindersTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderTableViewController: UITableViewController, Storyboarded {
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageTextField: UITextField!
    @IBOutlet weak var reminderSoundSwitch: UISwitch!
    
    @IBAction func cancelReminderButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.unwindSegueToReminders, sender: self)
    }
    
    @IBAction func createReminderButton(_ sender: Any) {
        scheduleNotification()
        performSegue(withIdentifier: Constants.unwindSegueToReminders, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
