//
//  UpdateReminderTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications
import MaterialComponents.MaterialTextFields

protocol UpdateReminderTableViewControllerDelegate: AnyObject {
    func didFinishUpdatingReminder(_ updateReminderTableViewController: UpdateReminderTableViewController)
}

class UpdateReminderTableViewController: UITableViewController, Storyboarded {
    
    public weak var delegate: UpdateReminderTableViewControllerDelegate?
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderSoundSwitch: UISwitch!
    @IBOutlet weak var messageTextBox: MDCTextField!
    
    var messageTextBoxController: MDCTextInputControllerOutlined!
    
    var reminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = localizedString(forKey: "update_reminder")
        
        reminderDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        self.view.backgroundColor = .workoutBackgroundColor
        self.tableView.backgroundColor = .workoutBackgroundColor
        self.tableView.separatorColor = .leaderboardGray
        self.tableView.sectionIndexColor = .white
        
        messageTextBox.delegate = self
        messageTextBox.tintColor = .white
        messageTextBox.textColor = .white
        messageTextBox.setupToolbar(view: self.view)

        messageTextBoxController = MDCTextInputControllerOutlined(textInput: messageTextBox)
        messageTextBoxController.setupKTTextFieldController()
        messageTextBoxController.placeholderText = localizedString(forKey: "reminder_message")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: localizedString(forKey: "update"), style: .plain, target: self, action: #selector(updateReminder))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderDatePicker.setDate((reminder?.Time)!, animated: true)
        messageTextBox.text = reminder?.Message
        reminderSoundSwitch.isOn = (reminder?.WithSound)!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KTTableHeaderView()
        
        switch section {
        case 0:
            headerView.titleLabel.text = localizedString(forKey: "time_of_reminder")
        case 1:
            headerView.titleLabel.text = localizedString(forKey: "configuration")
        default:
            headerView.titleLabel.text = ""
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = Fonts.subHeaderFont
    }
    
    @objc func updateReminder()
    {
        rescheduleNotification()
        
        self.delegate?.didFinishUpdatingReminder(self)
    }
    
    func rescheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = localizedString(forKey: "workout_notification_default_title")
        content.body = messageTextBox.text ?? localizedString(forKey: "workout_notification_default_message")
        
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

extension UpdateReminderTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
