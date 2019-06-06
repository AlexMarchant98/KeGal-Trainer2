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
    
    class func getWorkoutByLevel(_ context: NSManagedObjectContext, _ level: String) throws -> Workout?
    {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.predicate = NSPredicate(format: "level.level = %@", level as CVarArg)
        do {
            if let workout = try context.fetch(request).first
            {
                return workout
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func addWorkout(_ context: NSManagedObjectContext, _ workoutDate: WorkoutDate, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32)
    {
        let workout = Workout(context: context)
        workout.rep_count = repCount
        workout.rep_length = repLength
        workout.rest_length = restLength
        workout.workout_date = workoutDate
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
    
    class func addLevelWorkout(_ context: NSManagedObjectContext, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32, _ level : Level)
    {
        let workout = Workout(context: context)
        workout.rep_count = repCount
        workout.rep_length = repLength
        workout.rest_length = restLength
        workout.level = level
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
    
    
}
