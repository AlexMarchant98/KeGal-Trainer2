//
//  RemindersTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications
import MaterialComponents.MaterialTextFields

protocol AddReminderTableViewControllerDelegate: AnyObject {
    func didAddReminder(_ addReminderTableViewController: AddReminderTableViewController)
}

class AddReminderTableViewController: UITableViewController, Storyboarded {
    
    public weak var delegate: AddReminderTableViewControllerDelegate?
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderSoundSwitch: UISwitch!
    @IBOutlet weak var messageTextBox: MDCTextField!
    
    var messageTextBoxController: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Reminder"
        
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
        messageTextBoxController.placeholderText = "Reminder Message"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addReminder))
    }
    
    @objc func addReminder()
    {
        scheduleNotification()
        
        self.delegate?.didAddReminder(self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KTTableHeaderView()
        
        switch section {
        case 0:
            headerView.titleLabel.text = "Time Of Reminder"
        case 1:
            headerView.titleLabel.text = "Configuration"
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
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Workout Time!"
        content.body = messageTextBox.text ?? "Lets get this workout done!"
        
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

extension AddReminderTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
