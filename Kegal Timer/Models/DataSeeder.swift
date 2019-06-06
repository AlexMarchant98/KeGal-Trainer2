//
//  DataSeeder.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/05/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import CoreData

protocol IDataSeeder {
    
    init(context: NSManagedObjectContext)
    
    func seedData()
}

public class DataSeeder : IDataSeeder {
    
    let context: NSManagedObjectContext
    
    required init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seedData() {
        seedStages()
        seedLevels()
        seedWorkouts()
    }
    
    private func seedStages()
    {
        let stages = [
            (stage: 1, unlocked: true, completed: false),
            (stage: 2, unlocked: false, completed: false),
            (stage: 3, unlocked: false, completed: false),
            (stage: 4, unlocked: false, completed: false),
            (stage: 5, unlocked: false, completed: false)
        ]
        
        for stage in stages {
            Stage.addStage(context, Int32(stage.stage), stage.unlocked, stage.completed)
        }
    }
    
    private func seedLevels()
    {
        let firstStage = try! Stage.getStageByStageNumber(context, 1)
        let secondStage = try! Stage.getStageByStageNumber(context, 2)
        let thirdStage = try! Stage.getStageByStageNumber(context, 3)
        let fourthStage = try! Stage.getStageByStageNumber(context, 4)
        let fifthStage = try! Stage.getStageByStageNumber(context, 5)
        
        let levels = [
            (level: "1.1", unlocked: true, completed: false, order: 0, stage: firstStage!),
//            (level: "1.2", unlocked: false, completed: false, order: 1, stage: firstStage!),
//            (level: "1.3", unlocked: false, completed: false, order: 2, stage: firstStage!),
//            (level: "1.4", unlocked: false, completed: false, order: 3, stage: firstStage!),
//            (level: "1.5", unlocked: false, completed: false, order: 4, stage: firstStage!),
//            (level: "1.6", unlocked: false, completed: false, order: 5, stage: firstStage!),
//            (level: "1.7", unlocked: false, completed: false, order: 6, stage: firstStage!),
//            (level: "1.8", unlocked: false, completed: false, order: 7, stage: firstStage!),
//            (level: "1.9", unlocked: false, completed: false, order: 8, stage: firstStage!),
//            (level: "1.10", unlocked: false, completed: false, order: 9, stage: firstStage!),
            
            (level: "2.1", unlocked: false, completed: false, order: 0, stage: secondStage!),
            (level: "2.2", unlocked: false, completed: false, order: 1, stage: secondStage!),
//            (level: "2.3", unlocked: false, completed: false, order: 2, stage: secondStage!),
//            (level: "2.4", unlocked: false, completed: false, order: 3, stage: secondStage!),
//            (level: "2.5", unlocked: false, completed: false, order: 4, stage: secondStage!),
//            (level: "2.6", unlocked: false, completed: false, order: 5, stage: secondStage!),
//            (level: "2.7", unlocked: false, completed: false, order: 6, stage: secondStage!),
//            (level: "2.8", unlocked: false, completed: false, order: 7, stage: secondStage!),
//            (level: "2.9", unlocked: false, completed: false, order: 8, stage: secondStage!),
//            (level: "2.10", unlocked: false, completed: false, order: 9, stage: secondStage!),
//            (level: "2.11", unlocked: false, completed: false, order: 10, stage: secondStage!),
//            (level: "2.12", unlocked: false, completed: false, order: 11, stage: secondStage!),
            
            (level: "3.1", unlocked: false, completed: false, order: 0, stage: thirdStage!),
            (level: "3.2", unlocked: false, completed: false, order: 1, stage: thirdStage!),
            (level: "3.3", unlocked: false, completed: false, order: 2, stage: thirdStage!),
            (level: "3.4", unlocked: false, completed: false, order: 3, stage: thirdStage!),
            (level: "3.5", unlocked: false, completed: false, order: 4, stage: thirdStage!),
            (level: "3.6", unlocked: false, completed: false, order: 5, stage: thirdStage!),
            (level: "3.7", unlocked: false, completed: false, order: 6, stage: thirdStage!),
            (level: "3.8", unlocked: false, completed: false, order: 7, stage: thirdStage!),
            (level: "3.9", unlocked: false, completed: false, order: 8, stage: thirdStage!),
            (level: "3.10", unlocked: false, completed: false, order: 9, stage: thirdStage!),
            (level: "3.11", unlocked: false, completed: false, order: 10, stage: thirdStage!),
            (level: "3.12", unlocked: false, completed: false, order: 11, stage: thirdStage!),
            
            (level: "4.1", unlocked: false, completed: false, order: 0, stage: fourthStage!),
            (level: "4.2", unlocked: false, completed: false, order: 1, stage: fourthStage!),
            (level: "4.3", unlocked: false, completed: false, order: 2, stage: fourthStage!),
            (level: "4.4", unlocked: false, completed: false, order: 3, stage: fourthStage!),
            (level: "4.5", unlocked: false, completed: false, order: 4, stage: fourthStage!),
            (level: "4.6", unlocked: false, completed: false, order: 5, stage: fourthStage!),
            (level: "4.7", unlocked: false, completed: false, order: 6, stage: fourthStage!),
            (level: "4.8", unlocked: false, completed: false, order: 7, stage: fourthStage!),
            (level: "4.9", unlocked: false, completed: false, order: 8, stage: fourthStage!),
            (level: "4.10", unlocked: false, completed: false, order: 9, stage: fourthStage!),
            (level: "4.11", unlocked: false, completed: false, order: 10, stage: fourthStage!),
            (level: "4.12", unlocked: false, completed: false, order: 11, stage: fourthStage!),
            (level: "4.13", unlocked: false, completed: false, order: 12, stage: fourthStage!),
            (level: "4.14", unlocked: false, completed: false, order: 13, stage: fourthStage!),
            (level: "4.15", unlocked: false, completed: false, order: 14, stage: fourthStage!),
            
            (level: "5.1", unlocked: false, completed: false, order: 0, stage: fifthStage!),
            (level: "5.2", unlocked: false, completed: false, order: 1, stage: fifthStage!),
            (level: "5.3", unlocked: false, completed: false, order: 2, stage: fifthStage!),
            (level: "5.4", unlocked: false, completed: false, order: 3, stage: fifthStage!),
            (level: "5.5", unlocked: false, completed: false, order: 4, stage: fifthStage!),
            (level: "5.6", unlocked: false, completed: false, order: 5, stage: fifthStage!),
            (level: "5.7", unlocked: false, completed: false, order: 6, stage: fifthStage!),
            (level: "5.8", unlocked: false, completed: false, order: 7, stage: fifthStage!),
            (level: "5.9", unlocked: false, completed: false, order: 8, stage: fifthStage!),
            (level: "5.10", unlocked: false, completed: false, order: 9, stage: fifthStage!),

        ]
        
        for level in levels {
            Level.addLevel(context, level.level, level.unlocked, level.completed, Int32(level.order), level.stage)
        }
    }
    
    private func seedWorkouts()
    {
        let level1_1 = try! Level.getLevel(context, "1.1")
//        let level1_2 = try! Level.getLevel(context, "1.2")
//        let level1_3 = try! Level.getLevel(context, "1.3")
//        let level1_4 = try! Level.getLevel(context, "1.4")
//        let level1_5 = try! Level.getLevel(context, "1.5")
//        let level1_6 = try! Level.getLevel(context, "1.6")
//        let level1_7 = try! Level.getLevel(context, "1.7")
//        let level1_8 = try! Level.getLevel(context, "1.8")
//        let level1_9 = try! Level.getLevel(context, "1.9")
//        let level1_10 = try! Level.getLevel(context, "1.10")
        
        let level2_1 = try! Level.getLevel(context, "2.1")
        let level2_2 = try! Level.getLevel(context, "2.2")
//        let level2_3 = try! Level.getLevel(context, "2.3")
//        let level2_4 = try! Level.getLevel(context, "2.4")
//        let level2_5 = try! Level.getLevel(context, "2.5")
//        let level2_6 = try! Level.getLevel(context, "2.6")
//        let level2_7 = try! Level.getLevel(context, "2.7")
//        let level2_8 = try! Level.getLevel(context, "2.8")
//        let level2_9 = try! Level.getLevel(context, "2.9")
//        let level2_10 = try! Level.getLevel(context, "2.10")
//        let level2_11 = try! Level.getLevel(context, "2.11")
//        let level2_12 = try! Level.getLevel(context, "2.12")
        
        let level3_1 = try! Level.getLevel(context, "3.1")
        let level3_2 = try! Level.getLevel(context, "3.2")
        let level3_3 = try! Level.getLevel(context, "3.3")
        let level3_4 = try! Level.getLevel(context, "3.4")
        let level3_5 = try! Level.getLevel(context, "3.5")
        let level3_6 = try! Level.getLevel(context, "3.6")
        let level3_7 = try! Level.getLevel(context, "3.7")
        let level3_8 = try! Level.getLevel(context, "3.8")
        let level3_9 = try! Level.getLevel(context, "3.9")
        let level3_10 = try! Level.getLevel(context, "3.10")
        let level3_11 = try! Level.getLevel(context, "3.11")
        let level3_12 = try! Level.getLevel(context, "3.12")
        
        let level4_1 = try! Level.getLevel(context, "4.1")
        let level4_2 = try! Level.getLevel(context, "4.2")
        let level4_3 = try! Level.getLevel(context, "4.3")
        let level4_4 = try! Level.getLevel(context, "4.4")
        let level4_5 = try! Level.getLevel(context, "4.5")
        let level4_6 = try! Level.getLevel(context, "4.6")
        let level4_7 = try! Level.getLevel(context, "4.7")
        let level4_8 = try! Level.getLevel(context, "4.8")
        let level4_9 = try! Level.getLevel(context, "4.9")
        let level4_10 = try! Level.getLevel(context, "4.10")
        let level4_11 = try! Level.getLevel(context, "4.11")
        let level4_12 = try! Level.getLevel(context, "4.12")
        let level4_13 = try! Level.getLevel(context, "4.13")
        let level4_14 = try! Level.getLevel(context, "4.14")
        let level4_15 = try! Level.getLevel(context, "4.15")
        
        let level5_1 = try! Level.getLevel(context, "5.1")
        let level5_2 = try! Level.getLevel(context, "5.2")
        let level5_3 = try! Level.getLevel(context, "5.3")
        let level5_4 = try! Level.getLevel(context, "5.4")
        let level5_5 = try! Level.getLevel(context, "5.5")
        let level5_6 = try! Level.getLevel(context, "5.6")
        let level5_7 = try! Level.getLevel(context, "5.7")
        let level5_8 = try! Level.getLevel(context, "5.8")
        let level5_9 = try! Level.getLevel(context, "5.9")
        let level5_10 = try! Level.getLevel(context, "5.10")
        
        let workouts = [
            (repCount: 1, repLength: 1, restLength: 1, level: level1_1),
//            (repCount: 5, repLength: 4, restLength: 3, level: level1_2),
//            (repCount: 5, repLength: 4, restLength: 2, level: level1_3),
//            (repCount: 5, repLength: 5, restLength: 2, level: level1_4),
//            (repCount: 6, repLength: 5, restLength: 2, level: level1_5),
//            (repCount: 8, repLength: 5, restLength: 4, level: level1_6),
//            (repCount: 5, repLength: 3, restLength: 3, level: level1_7),
//            (repCount: 6, repLength: 3, restLength: 3, level: level1_8),
//            (repCount: 5, repLength: 3, restLength: 3, level: level1_9),
//            (repCount: 5, repLength: 3, restLength: 3, level: level1_10),
            
            (repCount: 1, repLength: 1, restLength: 1, level: level2_1),
            (repCount: 1, repLength: 2, restLength: 1, level: level2_2),
//            (repCount: 5, repLength: 4, restLength: 2, level: level2_3),
//            (repCount: 5, repLength: 5, restLength: 2, level: level2_4),
//            (repCount: 6, repLength: 5, restLength: 2, level: level2_5),
//            (repCount: 8, repLength: 5, restLength: 4, level: level2_6),
//            (repCount: 5, repLength: 3, restLength: 3, level: level2_7),
//            (repCount: 6, repLength: 3, restLength: 3, level: level2_8),
//            (repCount: 5, repLength: 3, restLength: 3, level: level2_9),
//            (repCount: 5, repLength: 3, restLength: 3, level: level2_10),
//            (repCount: 5, repLength: 3, restLength: 3, level: level2_11),
//            (repCount: 5, repLength: 3, restLength: 3, level: level2_12),
            
            (repCount: 5, repLength: 3, restLength: 3, level: level3_1),
            (repCount: 5, repLength: 4, restLength: 3, level: level3_2),
            (repCount: 5, repLength: 4, restLength: 2, level: level3_3),
            (repCount: 5, repLength: 5, restLength: 2, level: level3_4),
            (repCount: 6, repLength: 5, restLength: 2, level: level3_5),
            (repCount: 8, repLength: 5, restLength: 4, level: level3_6),
            (repCount: 5, repLength: 3, restLength: 3, level: level3_7),
            (repCount: 6, repLength: 3, restLength: 3, level: level3_8),
            (repCount: 5, repLength: 3, restLength: 3, level: level3_9),
            (repCount: 5, repLength: 3, restLength: 3, level: level3_10),
            (repCount: 5, repLength: 3, restLength: 3, level: level3_11),
            (repCount: 5, repLength: 3, restLength: 3, level: level3_12),
            
            (repCount: 5, repLength: 3, restLength: 3, level: level4_1),
            (repCount: 5, repLength: 4, restLength: 3, level: level4_2),
            (repCount: 5, repLength: 4, restLength: 2, level: level4_3),
            (repCount: 5, repLength: 5, restLength: 2, level: level4_4),
            (repCount: 6, repLength: 5, restLength: 2, level: level4_5),
            (repCount: 8, repLength: 5, restLength: 4, level: level4_6),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_7),
            (repCount: 6, repLength: 3, restLength: 3, level: level4_8),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_9),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_10),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_11),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_12),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_13),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_14),
            (repCount: 5, repLength: 3, restLength: 3, level: level4_15),
            
            (repCount: 5, repLength: 3, restLength: 3, level: level5_1),
            (repCount: 5, repLength: 4, restLength: 3, level: level5_2),
            (repCount: 5, repLength: 4, restLength: 2, level: level5_3),
            (repCount: 5, repLength: 5, restLength: 2, level: level5_4),
            (repCount: 6, repLength: 5, restLength: 2, level: level5_5),
            (repCount: 8, repLength: 5, restLength: 4, level: level5_6),
            (repCount: 5, repLength: 3, restLength: 3, level: level5_7),
            (repCount: 6, repLength: 3, restLength: 3, level: level5_8),
            (repCount: 5, repLength: 3, restLength: 3, level: level5_9),
            (repCount: 5, repLength: 3, restLength: 3, level: level5_10),

        ]
        
        for workout in workouts {
            Workout.addLevelWorkout(context, Int32(workout.repCount), Int32(workout.repLength), Int32(workout.restLength), workout.level!)
        }
    }
}
