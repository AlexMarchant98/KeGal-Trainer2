//
//  StageTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/05/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import FBAudienceNetwork

class StageTableViewController: UITableViewController, GADBannerViewDelegate, Storyboarded {
    
    weak var coordinator: StagesCoordinator?
    var adServer: AdServer!
    
    let userPreferences = UserDefaults.standard
    
    var adBannerView: GADBannerView!
    var audienceNetworkBannerView: FBAdView!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var stages = [Stage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        getStages()
    }
    
    override func viewDidLoad() {
        title = localizedString(forKey: "stages")
        
        self.view.backgroundColor = .workoutBackgroundColor
        self.tableView.backgroundColor = .workoutBackgroundColor
        self.tableView.separatorColor = .clear
        self.tableView.sectionIndexColor = .white
        
        navigationItem.setLeftBarButton(nil, animated: false)
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        
        if let bannerView = self.adServer.setupAdMobBannerView(
            adId: Constants.stagesTabBannerAdId,
            viewController: self,
            bannerContainerView: self.tableView!.tableHeaderView!) {
            
            self.adBannerView = bannerView
        }
        if let returnedAudienceNetworkBannerView = self.adServer.setupAudienceNetworkBannerView(
            placementId: Constants.audienceNetworkTabsBannerAdPlacementId,
            viewController: self,
            bannerContainerView: self.tableView!.tableHeaderView!) {
            
            self.audienceNetworkBannerView = returnedAudienceNetworkBannerView
        }
    }
    
    func getStages()
    {
        if let context = container?.viewContext {
            do {
                self.stages = try Stage.getAllStages(context) ?? [Stage]()
            } catch {
                print("An error has occured when trying to access the stages")
            }
        }
    }
    
    func getLevelByOrder(stage: Int, order: Int) -> Level?
    {
        if let context = container?.viewContext {
            do {
                return try Level.getLevelByOrder(context, stage, order)
            } catch {
                print("An error has occured when trying to get a level by stage \(stage) and order \(order)")
            }
        }
        
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return stages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages[section].levels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KTTableHeaderView()
        
        let stage = stages[section]
        
        if(stage.completed) {
            headerView.backgroundColor = .appGreen
            headerView.titleLabel.text = "\(localizedString(forKey: "stage")) \(stages[section].stage)"
        } else if(stage.unlocked) {
            headerView.backgroundColor = .workoutBackgroundColor
            headerView.titleLabel.text = "\(localizedString(forKey: "stage")) \(stages[section].stage)"
        } else {
            headerView.backgroundColor = .leaderboardGray
            headerView.titleLabel.text = "\(localizedString(forKey: "stage")) \(stages[section].stage) \(localizedString(forKey: "locked"))"
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "level", for: indexPath) as! LevelTableViewCell
        
        let level = getLevelByOrder(stage: indexPath.section + 1, order: indexPath.row)
        
        cell.level = level!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let levelCell = cell as? LevelTableViewCell
        {
            let level = getLevelByOrder(stage: indexPath.section + 1, order: indexPath.row)
            
            levelCell.levelDisplay = level!
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let levelCell = cell as? LevelTableViewCell
        {
            levelCell.resetDisplay()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let level = tableView.cellForRow(at: indexPath) as? LevelTableViewCell
            else {
                return
            }
        
        let levelAlert = UIAlertController(
            title: "\(localizedString(forKey: "level")) " + level.level.level!,
            message: localizedString(forKey: "tackle_level_message"),
            preferredStyle: coordinator?.getAlertStyle() ?? UIAlertController.Style.alert)
        
        levelAlert.addAction(UIAlertAction(title: localizedString(forKey: "yes"), style: UIAlertAction.Style.default, handler: { (_) in self.setWorkoutSettings(level.level!); self.tabBarController!.selectedIndex = 2;}))
        levelAlert.addAction(UIAlertAction(title: localizedString(forKey: "no"), style: UIAlertAction.Style.destructive))
        
        self.present(levelAlert, animated: true, completion: nil)
    }
    
    private func setWorkoutSettings(_ level: Level)
    {
        if let context = container?.viewContext {
            do {
                let workout = try Workout.getWorkoutByLevel(context, level.level!)
                
                userPreferences.set(workout?.rep_count, forKey: Constants.repsPerSet)
                userPreferences.set(workout?.rep_length, forKey: Constants.repLength)
                userPreferences.set(workout?.rest_length, forKey: Constants.restLength)
                userPreferences.set(level.stage?.stage, forKey: Constants.stage)
                userPreferences.set(level.level!, forKey: Constants.level)
                userPreferences.set(level.order, forKey: Constants.levelOrder)
                
            } catch {
                print("An error has occured when trying to access the stages")
            }
            
            RequestReview.levelsRequestReview()
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error.description)
    }

}
