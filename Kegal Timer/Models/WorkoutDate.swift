//
//  WorkoutDate.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/01/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class WorkoutDate: NSManagedObject {
    
    class func getWorkoutDate(_ context: NSManagedObjectContext, _ date: Date) throws -> WorkoutDate?
    {
        let request: NSFetchRequest<WorkoutDate> = WorkoutDate.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", date.stripTime() as CVarArg)
        do {
            if let workoutDate = try context.fetch(request).first
            {
                return workoutDate
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func addWorkoutDate(_ context: NSManagedObjectContext, _ date: Date)
    {
        let workoutDate = WorkoutDate(context: context)
        
        workoutDate.date = date.stripTime()
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
}
