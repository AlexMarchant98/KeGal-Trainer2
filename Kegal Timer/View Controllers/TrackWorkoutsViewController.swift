//
//  FirstViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 23/10/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class TrackWorkoutsViewController: UIViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getWorkoutDate(date: Date) throws  -> WorkoutDate
    {
        let context: NSManagedObjectContext = getContext()
        let request: NSFetchRequest<WorkoutDate> = WorkoutDate.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        do {
            return try (context.fetch(request).first)!
        } catch {
            throw error
        }
    }
    
    func addWorkoutDate(_ date: Date)
    {
        let context: NSManagedObjectContext = getContext()
        let workoutDate = WorkoutDate(context: context)
        workoutDate.date = date
        try! context.save()
    }
    
    func addWorkout(_ date: Date, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32)
    {
        var workoutDate: WorkoutDate!
        do {
            workoutDate = try getWorkoutDate(date: date)
        } catch {
            addWorkoutDate(date)
            workoutDate = try! getWorkoutDate(date: date)
        }
        let context: NSManagedObjectContext = getContext()
        let workout = Workout(context: context)
        workout.repCount = repCount
        workout.repLength = repLength
        workout.restLength = restLength
        workout.workoutDate = workoutDate
        try! context.save()
    }


}

