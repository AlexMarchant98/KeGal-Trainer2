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
    
    weak var coordinator: TimerCoordinator?
    
    let userPreferences = UserDefaults.standard
    
    @IBOutlet weak var image: ShapeView!
    @IBOutlet weak var workoutCompleteLabel: UILabel!
    @IBAction func nextLevel(_ sender: Any) {
        SwiftEntryKit.dismiss()
        coordinator?.didFinishWorkout()
    }
    @IBAction func dismissPopup(_ sender: Any) {
        SwiftEntryKit.dismiss()
        coordinator?.didFinishWork()
    }
    
    override func viewDidLoad() {
        image.path = UIBezierPath.tick
        image.draw(delay: 0, duration: 1)
        
        isLevelCompleted()
    }
    
    private func isLevelCompleted()
    {
        let level = userPreferences.string(forKey: Constants.level)
        if(level != nil)
        {
            if(!level!.isEmpty)
            {
                workoutCompleteLabel.text = "Level " + level! + " Completed!"
            }
        }
    }
}
