//
//  StageTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/05/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class StageTableViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: StagesCoordinator?
    
    
    let userPreferences = UserDefaults.standard
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var stages = [Stage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        getStages()
    }
    
    override func viewDidLoad() {
        title = "Stages"
        
        navigationItem.setLeftBarButton(nil, animated: false)
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Stage \(String(stages[section].stage))"
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
        
        let levelAlert = UIAlertController(title: "Level " + level.level.level!, message: "Would you like to tackle this level?", preferredStyle: coordinator?.getAlertStyle() ?? UIAlertController.Style.alert)
        
        levelAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in self.setWorkoutSettings(level.level!); self.tabBarController!.selectedIndex = 2}))
        levelAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive))
        
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
        }
    }

}
