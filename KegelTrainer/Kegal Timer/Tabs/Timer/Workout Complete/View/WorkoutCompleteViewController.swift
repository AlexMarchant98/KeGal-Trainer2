//
//  WorkoutCompleteViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import SwiftEntryKit

class WorkoutCompleteViewController: UIViewController, Storyboarded {
    
    var workoutCompletePresenter: WorkoutCompletePresenterProtocol!
    
    let userPreferences = UserDefaults.standard
    
    @IBOutlet weak var image: ShapeView!
    @IBOutlet weak var workoutCompleteLabel: KTTitle!
    @IBOutlet weak var levelMessage: KTHeader!
    @IBOutlet weak var pointsMessage: KTSubHeader!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func dismissPopup(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
    
    override func viewDidLoad() {
        
        workoutCompletePresenter.loadWorkoutStats()
        
        self.view.backgroundColor = .appGreen
        self.levelMessage.textColor = .white
        
        let closeIcon = UIImage(named: "close-icon")?.withRenderingMode(.alwaysTemplate)
        
        self.closeButton.setTitle("", for: .normal)
        self.closeButton.setImage(nil, for: .normal)
        self.closeButton.setBackgroundImage(closeIcon, for: .normal)
        self.closeButton.tintColor = UIColor.white
        self.closeButton.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        image.path = UIBezierPath.tick
        image.draw(delay: 0, duration: 1)
    }
    
    func setupWorkoutComplete() {
        self.workoutCompleteLabel.text = localizedString(forKey: "workout_complete")
        self.levelMessage.isHidden = false
    }
    
    func setupEarnPoints() {
        self.workoutCompleteLabel.text = localizedString(forKey: "points_earned")
        self.levelMessage.isHidden = true
    }
}

extension WorkoutCompleteViewController: WorkoutCompletePresenterView {
    func didLoadWorkoutStats(_ hasAnAccount: Bool, _ levelCompleted: String?, _ totalWorkouts: String?, _ pointsEarned: Double, _ maxDailyPointsEarned: Bool?) {
        
        if levelCompleted != nil && levelCompleted?.isEmpty == false {
            self.levelMessage.text = String(format: localizedString(forKey: "level_completed_message"), levelCompleted!)
        } else {
            if let totalWorkouts = totalWorkouts {
                if(Int(totalWorkouts)! >= 10 && Int(totalWorkouts)! <= 19) {
                    self.levelMessage.text = String(format: localizedString(forKey: "total_workouts_completed_ends_with_above_4_message"), totalWorkouts)
                } else if(totalWorkouts.last == "1") {
                    self.levelMessage.text = String(format: localizedString(forKey: "total_workouts_completed_ends_with_1_message"), totalWorkouts)
                } else if (totalWorkouts.last == "2") {
                    self.levelMessage.text = String(format: localizedString(forKey: "total_workouts_completed_ends_with_2_message"), totalWorkouts)
                } else if (totalWorkouts.last == "3") {
                    self.levelMessage.text = String(format: localizedString(forKey: "total_workouts_completed_ends_with_3_message"), totalWorkouts)
                } else {
                    self.levelMessage.text = String(format: localizedString(forKey: "total_workouts_completed_ends_with_above_4_message"), totalWorkouts)
                }
            } else {
                self.levelMessage.text = localizedString(forKey: "login_to_track_your_workouts_message")
            }
        }
        
            
        if(hasAnAccount) {
            if(pointsEarned == 1) {
                self.pointsMessage.text = String(format: localizedString(forKey: "earned_one_point"), pointsEarned)
            } else {
                self.pointsMessage.text = String(format: localizedString(forKey: "earned_more_than_one_point"), pointsEarned)
            }
            
            if let maxDailyPointsEarned = maxDailyPointsEarned {
                if(maxDailyPointsEarned) {
                    self.pointsMessage.text = localizedString(forKey: "max_daily_points_earned_message")
                }
            }
            
        } else {
            if(pointsEarned == 1) {
                self.pointsMessage.text = localizedString(forKey: "could_have_earned_one_point_message")
            } else {
                self.pointsMessage.text = String(format: localizedString(forKey: "could_have_earned_many_points_message"), pointsEarned)
            }
        }
    }
}
