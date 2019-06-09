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
    
    weak var coordinator: RemindersCoordinator?
    
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
        
        coordinator?.didFinishWork()
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
