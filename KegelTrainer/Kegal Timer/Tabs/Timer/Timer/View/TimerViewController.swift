//
//  SecondViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 23/10/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork

@IBDesignable
class TimerViewController: UIViewController, Storyboarded {
    
    var timerPresenter: TimerPresenterProtocol!
    
    let notificationCenter = NotificationCenter.default
    
    weak var didFailToLoadAdMobBannerObserver: NSObjectProtocol?
    weak var didFailToLoadAudienceNetworkBannerObserver: NSObjectProtocol?
    weak var didDismissInterstitialObserver: NSObjectProtocol?
    weak var didFailToLoadAdMobInterstitialObserver: NSObjectProtocol?
    
    var adServer: AdServer!
    
    @IBOutlet weak var timerButton: TimerButton!
    @IBOutlet weak var timeLabel: KTTitle!
    @IBOutlet weak var currentRepLabel: KTHeader!
    @IBOutlet weak var currentRepUICollectionView: UICollectionView!
    @IBOutlet weak var bannerAdContainerView: UIView!
    
    var repsDataSource: RepsDataSource?
    
    var adBannerView: GADBannerView!
    var audienceNetworkBannerView: FBAdView!
    
    let dispatchQueue = DispatchQueue(label: Constants.dispatchQueueLabel)
    let workoutCue = WorkoutCue()
    let queueTimer = QueueTimer()
    
    private var reps: [Int]!
    
    var workoutCompleted = false
    
    var repsPerSet: Int!
    var repLength: Int!
    var restLength: Int!
    
    var currentRep = 0
    var secondsRemaining: Int!
    var miliseconds = 100
    
    var dispatchWorkItem = DispatchWorkItem(block: {})
    var timer = Timer()
    
    var isTimerRunning = false
    var isRestState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentRepLabel.font = Fonts.headerFont
        self.currentRepLabel.textColor = .white
        
        if let bannerView = self.adServer.setupAdMobBannerView(
            adId: Constants.timerTabBannerAdId,
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
        
        timerPresenter.getWorkoutInformation()
        
        workoutCompleted = false
        
        registerForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetTimer()
    }
    
    @IBAction func backButton(_ sender: Any) {
        if(isRestState)
        {
            repsDataSource?.updateCurrentRep(by: -1)
        } else {
            repsDataSource?.updateCurrentRep(by: 0)
        }
        
        resetUI()
    }
    
    @IBAction func beginWorkoutButton(_ sender: Any) {
        if isTimerRunning == false
        {
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
        resetTimer()
    }
    
    private func registerForNotifications() {
        
        didFailToLoadAdMobBannerObserver = notificationCenter
            .addObserver(forName: .didFailToLoadAdMobBanner,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                            self?.adBannerView.isHidden = true
                            self?.audienceNetworkBannerView.isHidden = false
        }
        
        didFailToLoadAudienceNetworkBannerObserver = notificationCenter
            .addObserver(forName: .didFailToLoadAudienceNetworkBanner,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                         self?.audienceNetworkBannerView.isHidden = true
        }
        
        didDismissInterstitialObserver = notificationCenter
            .addObserver(forName: .didDismissInterstitial,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if(self.tabBarController!.selectedIndex == 2) {
                    if(self.workoutCompleted) {
                        self.completeWorkout()
                    }
                } else {
                    self.deregisterNotifications()
                }
        }
        
        didFailToLoadAdMobInterstitialObserver = notificationCenter
            .addObserver(forName: .didFailToLoadAdMobInterstitial,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if(self.tabBarController!.selectedIndex == 2) {
                    if(self.workoutCompleted) {
                        self.completeWorkout()
                    }
                } else {
                    self.deregisterNotifications()
                }
            }
    }
    
    private func deregisterNotifications() {
        
        if let didFailToLoadAdMobBannerObserver = self.didFailToLoadAdMobBannerObserver {
            notificationCenter.removeObserver(didFailToLoadAdMobBannerObserver, name: .didDismissInterstitial, object: nil)
        }
        
        if let didFailToLoadAudienceNetworkBannerObserver = self.didFailToLoadAudienceNetworkBannerObserver {
            notificationCenter.removeObserver(didFailToLoadAudienceNetworkBannerObserver, name: .didFailToLoadAdMobInterstitial, object: nil)
        }
        
        if let didDismissInterstitialObserver = self.didDismissInterstitialObserver {
            notificationCenter.removeObserver(didDismissInterstitialObserver, name: .didDismissInterstitial, object: nil)
        }
        
        if let didFailToLoadAdMobInterstitialObserver = self.didFailToLoadAdMobInterstitialObserver {
            notificationCenter.removeObserver(didFailToLoadAdMobInterstitialObserver, name: .didFailToLoadAdMobInterstitial, object: nil)
        }
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
            repsDataSource?.updateCurrentRep(by: 1)
            
            self.timeLabel.text = self.timeString(time: TimeInterval(0), miliseconds: 0)
            
            if(currentRep < self.repsPerSet - 1) {
                
                if(workoutCue.displayVisualCue() == true)
                {
                    self.view.backgroundColor = UIColor.restBackgroundColor
                }
                
                workoutCue.playRestSoundBite()
                workoutCue.vibrateDevice()
                
                isRestState = true
                
                timerButton.animateCircle()
                
                queueItems()
                queueTimer.configAndStart(delayTime: TimeInterval(self.restLength))
            }
        } else {
            timeLabel.text = timeString(time: TimeInterval(secondsRemaining), miliseconds: miliseconds)
        }
    }
    
    private func queueItems() {
        queueItems(delayTime: .now() + .seconds(self.restLength))
    }
    
    private func queueItems(animationBeginTime : CFTimeInterval) {
        queueItems(delayTime: .now() + .seconds(self.restLength - Int(animationBeginTime)))
    }
    
    private func queueItems(delayTime: DispatchTime) {
        dispatchWorkItem = DispatchWorkItem(qos: .userInteractive, block: {
            self.secondsRemaining = self.repLength - 1
            self.view.backgroundColor = UIColor.workoutBackgroundColor
            self.runTimer()
            self.timerButton.animateableTrackLayer.removeAnimation(forKey: Constants.strokeEndAnimation)
            self.workoutCue.playBeginSoundBite()
            self.workoutCue.vibrateDevice()
            self.isRestState = false
        })
        
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: self.dispatchWorkItem)
    }
    
    private func resetTimer()
    {
        repsDataSource?.resetReps()
        resetUI()
    }
    
    private func resetUI()
    {
        timer.invalidate()
        isTimerRunning = false
        isRestState = false
        
        dispatchWorkItem.cancel()
        
        view.backgroundColor = UIColor.workoutBackgroundColor
        
        secondsRemaining = self.repLength - 1
        
        timeLabel.text! = timeString(time: TimeInterval(self.repLength), miliseconds: 0)
        
        timerButton.startTriangleShapeLayer()
        timerButton.animateableTrackLayer.removeAllAnimations()
        
        workoutCompleted = false
    }
    
    func setupWorkout() {
        
        if(self.repsPerSet > 1) {
            reps = Array(1...self.repsPerSet)
        }
        else
        {
            reps = Array(1...1)
        }
        
        secondsRemaining = self.repLength - 1
        
        let contentInset = (self.view.frame.width / 2) - 28.1
        
        currentRepUICollectionView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 0, right: contentInset)
        
        timeLabel.text! = timeString(time: TimeInterval(self.repLength), miliseconds: 0)
    }
    
    func completeWorkout() {
        self.timerPresenter.completeWorkout(self.repsPerSet, self.repLength, self.restLength)

        resetTimer()
    }
}

extension TimerViewController: TimerPresenterView {
    func didGetWorkoutInformation(_ repsPerSet: Int, _ repLength: Int, _ restLength: Int) {
        
        self.repsPerSet = repsPerSet
        self.repLength = repLength
        self.restLength = restLength
        self.secondsRemaining = repLength - 1
        
        self.setupWorkout()
        
        self.repsDataSource = RepsDataSource(
            reps: self.reps,
            repsPerSet: self.repsPerSet,
            collectionView: currentRepUICollectionView,
            delegate: self)
        
        currentRepUICollectionView.dataSource = repsDataSource!
        currentRepUICollectionView.delegate = repsDataSource!
        
        repsDataSource!.focusCollectionView()
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}

extension TimerViewController: RepsDataSourceDelegate {
    func allRepsCompleted() {
        
        self.workoutCompleted = true
        
        workoutCue.playWorkoutCompleteSoundBite()
        
        resetTimer()
        dispatchWorkItem.cancel()
        
        if(!adServer.areAdsDisabled) {
            adServer.displayInterstitialAd(viewController: self)
            
            adServer.reloadAds()
        } else {
            completeWorkout()
        }
    }
}
