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
import FBAudienceNetwork

class TrackWorkoutsViewController: UIViewController, Storyboarded {
    
    var adServer: AdServer!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: KTSubTitle!
    @IBOutlet weak var lastMonth: KTHeader!
    @IBOutlet weak var currentMonth: KTSubTitle!
    @IBOutlet weak var nextMonth: KTHeader!
    @IBOutlet weak var bannerAdContainerView: UIView!
    
    let formatter = DateFormatter()
    
    var adBannerView: GADBannerView!
    var audienceNetworkBannerView: FBAdView!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = localizedString(forKey: "track_my_workouts")
        self.view.backgroundColor = .workoutBackgroundColor
        
        lastMonth.textColor = .white
        lastMonth.alpha = 0.35
        nextMonth.textColor = .white
        nextMonth.alpha = 0.35
        
        setupCalendarView()
        
        if let bannerView = self.adServer.setupAdMobBannerView(
            adId: Constants.trackTabBannerAdId,
            viewController: self,
            bannerContainerView: self.bannerAdContainerView) {
            
            self.adBannerView = bannerView
        }
        if let returnedAudienceNetworkBannerView = self.adServer.setupAudienceNetworkBannerView(
            placementId: Constants.audienceNetworkTabsBannerAdPlacementId,
            viewController: self,
            bannerContainerView: self.bannerAdContainerView) {
            
            self.audienceNetworkBannerView = returnedAudienceNetworkBannerView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
        
        calendarView.scrollToDate(Date())
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden = true
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
        guard let myCustomCell = view as? DateCell else { return }
        
            if cellState.dateBelongsTo == .thisMonth {
                switch (workoutCount) {
                case 0:
                    myCustomCell.dateLabel.textColor = .white
                default:
                    myCustomCell.dateLabel.textColor = .workoutBackgroundColor
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
        let myCustomCell = cell as! DateCell
        
        myCustomCell.dateLabel.text = cellState.text
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.trackWorkoutsCalendarViewCellReuseIdentifier, for: indexPath) as! DateCell
        
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
            backgroundColour = UIColor.appRed
        case 2:
            backgroundColour = UIColor.restBackgroundColor
        default:
            backgroundColour = UIColor.appGreen
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
                        alertMessage = localizedString(forKey: "one_workout_performed_message")
                    } else {
                        alertMessage = String(format: localizedString(forKey: "multiple_workouts_performed_message"), "\(String(workoutDate.workouts!.count))")
                    }
                } else {
                    alertMessage = localizedString(forKey: "no_workouts_performed_message")
                }
            } catch {
                print("An error has occured when trying to access the WorkoutDate for \(date.description)")
            }
        }
        
        let presetName = localizedString(forKey: "workouts")
        
        let selectPresetAlert = UIAlertController(title: presetName, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        selectPresetAlert.addAction(UIAlertAction(title: localizedString(forKey: "ok"), style: UIAlertAction.Style.default, handler: { (action) in selectPresetAlert.dismiss(animated: true, completion: nil)}))
        
        self.present(selectPresetAlert, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewFromCalendar(from: visibleDates)
    }
}
