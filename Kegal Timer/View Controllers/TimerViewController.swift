//
//  SecondViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 23/10/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class TimerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Storyboarded {

    weak var coordinator: TimerCoordinator?
    
    @IBOutlet weak var timerButton: TimerButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentRepLabel: UILabel!
    @IBOutlet weak var currentRepUICollectionView: UICollectionView!
    
    @IBAction func backButton(_ sender: Any) {
        restartRep()
    }
    
    @IBAction func beginWorkoutButton(_ sender: Any) {
        if isTimerRunning == false
        {
            if(isWorkoutComplete)
            {
                resetViewUI()
            } else {
                isTimerRunning = true
                UIApplication.shared.isIdleTimerDisabled = true
                if (isRestState) {
                    timerButton.resumeLayer()
                    queueTimer.resume()
                    queueItems(delayTime: .now() + .seconds(Int(queueTimer.timeRemaining)))
                } else {
                    runTimer()
                    workoutCue.playBeginSoundBite()
                    workoutCue.vibrateDevice()
                }
            }
        }
        else
        {
            timer.invalidate()
            isTimerRunning = false
            
            if (isRestState) {
                timerButton.pauseLayer()
                dispatchWorkItem.cancel()
                queueTimer.pause()
            } else {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
    @IBAction func stopWorkoutButton(_ sender: Any) {
        resetViewUI()
    }
    
    let userPreferences = UserDefaults.standard
    let dispatchQueue = DispatchQueue(label: Constants.dispatchQueueLabel)
    let workoutCue = WorkoutCue()
    let queueTimer = QueueTimer()
    
    private var reps: [Int]!
    
    lazy var _repsPerSet = userPreferences.integer(forKey: Constants.repsPerSet)
    lazy var _repLength = userPreferences.integer(forKey: Constants.repLength)
    lazy var _restLength = userPreferences.integer(forKey: Constants.restLength)
    lazy var _stage = userPreferences.integer(forKey: Constants.stage)
    lazy var _level = userPreferences.string(forKey: Constants.level)
    lazy var _levelOrder = userPreferences.integer(forKey: Constants.levelOrder)
    lazy var secondsRemaining = _repLength - 1
    
    var miliseconds = 100
    var currentRep = 0
    
    var dispatchWorkItem = DispatchWorkItem(block: {})
    var timer = Timer()
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var _workoutDate: WorkoutDate?
    var _workout: Workout?
    
    var isTimerRunning = false
    var isWorkoutComplete = false
    var isRestState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _repsPerSet = userPreferences.integer(forKey: Constants.repsPerSet)
        _repLength = userPreferences.integer(forKey: Constants.repLength)
        _restLength = userPreferences.integer(forKey: Constants.restLength)
        _stage = userPreferences.integer(forKey: Constants.stage)
        _level = userPreferences.string(forKey: Constants.level) ?? ""
        _levelOrder = userPreferences.integer(forKey: Constants.levelOrder)
        
        if(_repsPerSet > 1) {
            reps = Array(1..._repsPerSet)
        }
        else
        {
            reps = Array(1...1)
        }
        currentRep = 0
        
        secondsRemaining = _repLength - 1
        
        
        let contentInset = (self.view.frame.width / 2) - 28.1
        
        currentRepUICollectionView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 0, right: contentInset)
        
        focusCollectionView()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func timeString(time: TimeInterval, miliseconds: Int) -> String
    {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", minutes, seconds, miliseconds)
    }
    
    @objc func updateTimer() {
        miliseconds -= 1
        if(miliseconds == 0)
        {
            secondsRemaining -= 1
            miliseconds = 99
        }
        if(secondsRemaining == -1)
        {
            timer.invalidate()
            workoutCue.playRestSoundBite()
            workoutCue.vibrateDevice()
            self.timeLabel.text = self.timeString(time: TimeInterval(0), miliseconds: 0)
            if(currentRep < _repsPerSet - 1) {
                if(workoutCue.displayVisualCue() == true)
                {
                    self.view.backgroundColor = UIColor.restBackgroundColor
                }
                
                isRestState = true
                
                timerButton.animateCircle()
                
                queueItems()
                queueTimer.configAndStart(delayTime: TimeInterval(_restLength))
                
                self.currentRep += 1
                
                focusCollectionView()
            } else {
                timerButton.isWorkoutComplete = true
                timerButton.checkMarkShapeLayer()
                isTimerRunning = false
                isWorkoutComplete = true
                miliseconds = 100
                
                workoutCue.playWorkoutCompleteSoundBite()
                if(workoutCue.displayVisualCue())
                {
                    self.view.backgroundColor = UIColor.workoutCompleteBackgroundColor
                }
                
                addWorkout(Date(), Int32(_repsPerSet), Int32(_repLength), Int32(_restLength))
                
                completeLevel()
                
                if #available(iOS 10.3, *) {
                    RequestReview.requestReview()
                }
                else {
                    // Review View is unvailable for lower versions. Please use your custom view.
                }
                
            }
        } else {
            timeLabel.text = timeString(time: TimeInterval(secondsRemaining), miliseconds: miliseconds)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = UIColor.clear
        return reps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch reps[indexPath.row] - 1 {
        case currentRep + 3:
            return CGSize(width: 56.2 / 4, height: 56.2)
        case currentRep + 2:
            return CGSize(width: 56.2 / 3, height: 56.2)
        case currentRep + 1:
            return CGSize(width: 56.2 / 2, height: 56.2)
        case currentRep:
            return CGSize(width: 56.2, height: 56.2)
        case currentRep - 1:
            return CGSize(width: 56.2 / 2, height: 56.2)
        case currentRep - 2:
            return CGSize(width: 56.2 / 3, height: 56.2)
        case currentRep - 3:
            return CGSize(width: 56.2 / 4, height: 56.2)
        default:
            return CGSize(width: 56.2 / 4, height: 56.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.repCollectionViewCellReuseIdentifier, for: indexPath) as! RepCollectionViewCell
        
        let mask = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: cell.bounds.midX, y: cell.bounds.midY),
                                radius: cell.bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        path.close()
        
        mask.frame = cell.bounds
        mask.path = path.cgPath
        
        var alpha = 1.0
        var color = UIColor.white
        var size = 0.0
        
        switch reps[indexPath.row] - 1 {
        case currentRep + 3:
            size = Constants.fontSize / 4
        case currentRep + 2:
            size = Constants.fontSize / 3
        case currentRep + 1:
            size = Constants.fontSize / 2
        case currentRep:
            color = .green
            size = Constants.fontSize
        case currentRep - 1:
            size = Constants.fontSize / 2
            alpha = 0.75
        case currentRep - 2:
            size = Constants.fontSize / 3
            alpha = 0.50
        case currentRep - 3:
            size = Constants.fontSize / 4
            alpha = 0.25
        default:
            color = .clear
            alpha = 0
        }
        
        cell.layer.mask = mask
        cell.repCount.text = String(reps[indexPath.row])
        cell.repCount.font = UIFont(name: Constants.fontName, size: CGFloat(size))
        cell.contentView.backgroundColor = color
        cell.contentView.alpha = CGFloat(alpha)
        cell.backgroundColor = UIColor.clear
        cell.alpha = cell.contentView.alpha
        
        return cell
    }
    
    func addWorkout(_ date: Date, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32) {
        if let context = container?.viewContext {
            do
            {
                if let existingWorkoutDate = try WorkoutDate.getWorkoutDate(context, date)
                {
                    Workout.addWorkout(context, existingWorkoutDate, repCount, repLength, restLength)
                } else {
                    WorkoutDate.addWorkoutDate(context, date)
                    if let addedWorkoutDate = try WorkoutDate.getWorkoutDate(context, date)
                    {
                        Workout.addWorkout(context, addedWorkoutDate, repCount, repLength, restLength)
                    } else {
                        print("Could not create a new workout date, please close the app and try again.")
                    }
                }
            } catch {
                print("Something has gone wrong whilst adding a new workout entry.")
            }
        }
    }
    
    func completeLevel()
    {
        if(!_level!.isEmpty)
        {
            if let context = container?.viewContext {
                Level.completeLevel(context, _level!)
                
                if(Level.unlockNextLevel(context, Int32(_stage), currentLevelOrder: Int32(_levelOrder)) == nil)
                {
                    let stage = Stage.unlockNextStage(context, Int32(_stage))
                    
                    do {
                        try Level.unlockFirstLevelOfStage(context, stage!.stage)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    private func queueItems() {
        queueItems(delayTime: .now() + .seconds(_restLength))
    }
    
    private func queueItems(animationBeginTime : CFTimeInterval) {
        queueItems(delayTime: .now() + .seconds(_restLength - Int(animationBeginTime)))
    }
    
    private func queueItems(delayTime: DispatchTime) {
        dispatchWorkItem = DispatchWorkItem(qos: .userInteractive, block: {
            self.secondsRemaining = self._repLength - 1
            self.view.backgroundColor = UIColor.workoutBackgroundColor
            self.runTimer()
            self.timerButton.animateableTrackLayer.removeAnimation(forKey: Constants.strokeEndAnimation)
            self.workoutCue.playBeginSoundBite()
            self.workoutCue.vibrateDevice()
            self.isRestState = false
        })
        
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: self.dispatchWorkItem)
    }
    
    private func restartRep()
    {
        timer.invalidate()
        isTimerRunning = false
        
        if(isRestState)
        {
            currentRep -= 1
        }
        isRestState = false
        
        secondsRemaining = _repLength - 1
        
        dispatchWorkItem.cancel()
        
        view.backgroundColor = UIColor.workoutBackgroundColor
        
        timeLabel.text! = timeString(time: TimeInterval(_repLength), miliseconds: 0)
        
        timerButton.startTriangleShapeLayer()
        timerButton.animateableTrackLayer.removeAllAnimations()
        
        focusCollectionView()
    }
    
    private func resetViewUI()
    {
        timer.invalidate()
        isTimerRunning = false
        isWorkoutComplete = false
        isRestState = false
        
        dispatchWorkItem.cancel()
        
        view.backgroundColor = UIColor.workoutBackgroundColor
        
        timeLabel.text! = timeString(time: TimeInterval(0), miliseconds: 0)
        
        timerButton.startTriangleShapeLayer()
        timerButton.animateableTrackLayer.removeAllAnimations()
        
        _repsPerSet = userPreferences.integer(forKey: Constants.repsPerSet)
        secondsRemaining = _repLength - 1
        
        currentRep = 0
        
        currentRepUICollectionView.reloadData()
        currentRepUICollectionView.scrollToItem(at: IndexPath(item: currentRep, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    private func focusCollectionView()
    {
        self.currentRepUICollectionView.reloadData()
        self.currentRepUICollectionView.reloadItems(at: generateIndexPaths())
        self.currentRepUICollectionView.scrollToItem(at: IndexPath(item: currentRep, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    private func generateIndexPaths() -> [IndexPath]
    {
        var indexPaths = [IndexPath]()
        
        if(currentRep - 5 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 5, section: 0))
        }
        if(currentRep - 4 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 4, section: 0))
        }
        if(currentRep - 3 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 3, section: 0))
        }
        if(currentRep - 2 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 2, section: 0))
        }
        if(currentRep - 1 >= 0)
        {
            indexPaths.append(IndexPath(row: currentRep - 1, section: 0))
        }
        
        indexPaths.append(IndexPath(row: currentRep, section: 0))
        
        if(currentRep + 1 < _repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 1, section: 0))
        }
        if(currentRep + 2 < _repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 2, section: 0))
        }
        if(currentRep + 3 < _repsPerSet)
        {
            indexPaths.append(IndexPath(row: currentRep + 3, section: 0))
        }
        
        return indexPaths
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetViewUI()
    }
}
