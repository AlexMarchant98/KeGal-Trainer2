//
//  Workout.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/01/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class Workout: NSManagedObject {
    
    class func addWorkout(_ context: NSManagedObjectContext, _ workoutDate: WorkoutDate, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32)
    {
        let workout = Workout(context: context)
        workout.repCount = repCount
        workout.repLength = repLength
        workout.restLength = restLength
        workout.workoutDate = workoutDate
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
}
