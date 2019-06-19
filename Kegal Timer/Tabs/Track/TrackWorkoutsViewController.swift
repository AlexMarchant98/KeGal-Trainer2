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
import GoogleMobileAds

class TrackWorkoutsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: TrackWorkoutsCoordinator?
    let adMobDisplayer = AdMobDisplayer()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: TopAlignedLabel!
    @IBOutlet weak var lastMonth: UILabel!
    @IBOutlet weak var currentMonth: UILabel!
    @IBOutlet weak var nextMonth: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let formatter = DateFormatter()
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        
        self.bannerView = self.adMobDisplayer.setupAdBannerView(self.bannerView, viewController: self, adUnitId: Constants.trackTabBannerAdId)
        
        self.adMobDisplayer.displayBannerAd(self.bannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
        
        calendarView.scrollToDate(Date())
    }
    
    func setupCalendarView() {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewFromCalendar(from: visibleDates)
        }
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState, _ workoutCount: Int = 0) {
        guard let myCustomCell = view as? CustomCell else { return }
        
            if cellState.dateBelongsTo == .thisMonth {
                switch (workoutCount) {
                case 0:
                    myCustomCell.dateLabel.textColor = .white
                default:
                    myCustomCell.dateLabel.textColor = .black
                }
            } else {
                myCustomCell.dateLabel.textColor = .gray
            }
    }
    
    func setupViewFromCalendar(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        
        lastMonth.text = formatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: date)!)
        currentMonth.text = formatter.string(from: date)
        nextMonth.text = formatter.string(from: Calendar.current.date(byAdding: .month, value: 1, to: date)!)
    }

}

extension TrackWorkoutsViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let calendarStartYear = currentYear - 1
        let calendarEndYear = currentYear + 1
        
        let startDate = formatter.date(from: "\(calendarStartYear) 01 01")!
        let endDate = formatter.date(from: "\(calendarEndYear) 12 31")!
        
        
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
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.trackWorkoutsCalendarViewCellReuseIdentifier, for: indexPath) as! CustomCell
        
        var workoutCount: Int = 0
        var backgroundColour: UIColor!
        
        if let context = container?.viewContext {
            do {
                if let workoutDate = try WorkoutDate.getWorkoutDate(context, date)
                {
                    workoutCount = (workoutDate.workouts?.count)!
                }
            } catch {
                print("An error has occured when trying to access the WorkoutDate for \(date.description)")
            }
        }
        
        switch (workoutCount) {
        case 0:
            backgroundColour = .clear
        case 1:
            backgroundColour = UIColor.rgb(r: 255, g: 38, b: 73)
        case 2:
            backgroundColour = UIColor.restBackgroundColor
        default:
            backgroundColour = UIColor.rgb(r: 0, g: 255, b: 75)
        }
        
        cell.dateLabel.text = cellState.text
        cell.workoutCountPreviewView.backgroundColor = backgroundColour
        
        handleCellTextColor(view: cell, cellState: cellState, workoutCount)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        var alertMessage: String?
        if let context = container?.viewContext {
            do {
                if let workoutDate = try WorkoutDate.getWorkoutDate(context, date)
                {
                    if(workoutDate.workouts!.count == 1) {
                        alertMessage = String(format: "You performed %@ workout on this day", String(workoutDate.workouts!.count))
                    } else {
                        alertMessage = String(format: "You performed %@ workouts on this day", String(workoutDate.workouts!.count))
                    }
                } else {
                    alertMessage = "You performed no workouts on this day"
                }
            } catch {
                print("An error has occured when trying to access the WorkoutDate for \(date.description)")
            }
        }
        
        let presetName = "Workouts"
        
        let selectPresetAlert = UIAlertController(title: presetName, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        selectPresetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in selectPresetAlert.dismiss(animated: true, completion: nil)}))
        
        self.present(selectPresetAlert, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewFromCalendar(from: visibleDates)
    }
}
