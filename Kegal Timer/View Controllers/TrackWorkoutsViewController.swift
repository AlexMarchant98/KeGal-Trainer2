//
//  FirstViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 23/10/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class TrackWorkoutsViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            myCustomCell.dateLabel.textColor = .black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dateLabel.textColor = .white
            } else {
                myCustomCell.dateLabel.textColor = .gray
            }
        }
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

extension TrackWorkoutsViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension TrackWorkoutsViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        
        myCustomCell.dateLabel.text = cellState.text
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
    }
}
