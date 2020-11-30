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
        self.workoutCompleteLabel.text = "Workout Complete"
        self.levelMessage.isHidden = false
    }
    
    func setupEarnPoints() {
        self.workoutCompleteLabel.text = "Points Earned"
        self.levelMessage.isHidden = true
    }
}

extension WorkoutCompleteViewController: WorkoutCompletePresenterView {
    func didLoadWorkoutStats(_ hasAnAccount: Bool, _ levelCompleted: String?, _ totalWorkouts: String?, _ pointsEarned: Double) {
        
        if levelCompleted != nil && levelCompleted?.isEmpty == false {
            self.levelMessage.text = "Level \(levelCompleted!) completed!"
        } else {
            if let totalWorkouts = totalWorkouts {
                if(totalWorkouts.last == "1") {
                    self.levelMessage.text = "That was your \(totalWorkouts)st workout!"
                } else if (totalWorkouts.last == "2") {
                    self.levelMessage.text = "That was your \(totalWorkouts)nd workout!"
                } else if (totalWorkouts.last == "3") {
                    self.levelMessage.text = "That was your \(totalWorkouts)rd workout!"
                } else {
                    self.levelMessage.text = "That was your \(totalWorkouts)th workout!"
                }
            } else {
                self.levelMessage.text = "Login to track your workouts"
            }
        }
        
            
        if(hasAnAccount) {
            if(pointsEarned == 1) {
                self.pointsMessage.text = "You earned \(pointsEarned) point"
            } else {
                self.pointsMessage.text = "You earned \(pointsEarned) points"
            }
        } else {
            if(pointsEarned == 1) {
                self.pointsMessage.text = "You could have earned \(pointsEarned) point for that workout"
            } else {
                self.pointsMessage.text = "You could have earned \(pointsEarned) points for that workout"
            }
        }
    }
}
