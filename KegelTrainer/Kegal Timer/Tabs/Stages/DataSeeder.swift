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
            (stage: 5, unlocked: false, completed: false),
            (stage: 6, unlocked: false, completed: false)
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
        let sixthStage = try! Stage.getStageByStageNumber(context, 6)
        
        let levels = [
            (level: "1.1", unlocked: true, completed: false, order: 0, stage: firstStage!),
            (level: "1.2", unlocked: false, completed: false, order: 1, stage: firstStage!),
            (level: "1.3", unlocked: false, completed: false, order: 2, stage: firstStage!),
            (level: "1.4", unlocked: false, completed: false, order: 3, stage: firstStage!),
            (level: "1.5", unlocked: false, completed: false, order: 4, stage: firstStage!),
            (level: "1.6", unlocked: false, completed: false, order: 5, stage: firstStage!),
            (level: "1.7", unlocked: false, completed: false, order: 6, stage: firstStage!),
            (level: "1.8", unlocked: false, completed: false, order: 7, stage: firstStage!),
            (level: "1.9", unlocked: false, completed: false, order: 8, stage: firstStage!),
            (level: "1.10", unlocked: false, completed: false, order: 9, stage: firstStage!),
            
            (level: "2.1", unlocked: false, completed: false, order: 0, stage: secondStage!),
            (level: "2.2", unlocked: false, completed: false, order: 1, stage: secondStage!),
            (level: "2.3", unlocked: false, completed: false, order: 2, stage: secondStage!),
            (level: "2.4", unlocked: false, completed: false, order: 3, stage: secondStage!),
            (level: "2.5", unlocked: false, completed: false, order: 4, stage: secondStage!),
            (level: "2.6", unlocked: false, completed: false, order: 5, stage: secondStage!),
            (level: "2.7", unlocked: false, completed: false, order: 6, stage: secondStage!),
            (level: "2.8", unlocked: false, completed: false, order: 7, stage: secondStage!),
            (level: "2.9", unlocked: false, completed: false, order: 8, stage: secondStage!),
            (level: "2.10", unlocked: false, completed: false, order: 9, stage: secondStage!),
            (level: "2.11", unlocked: false, completed: false, order: 10, stage: secondStage!),
            (level: "2.12", unlocked: false, completed: false, order: 11, stage: secondStage!),
            
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
            (level: "5.11", unlocked: false, completed: false, order: 10, stage: fifthStage!),
            (level: "5.12", unlocked: false, completed: false, order: 11, stage: fifthStage!),
            (level: "5.13", unlocked: false, completed: false, order: 12, stage: fifthStage!),
            (level: "5.14", unlocked: false, completed: false, order: 13, stage: fifthStage!),
            (level: "5.15", unlocked: false, completed: false, order: 14, stage: fifthStage!),
            (level: "5.16", unlocked: false, completed: false, order: 15, stage: fifthStage!),
            (level: "5.17", unlocked: false, completed: false, order: 16, stage: fifthStage!),
            (level: "5.18", unlocked: false, completed: false, order: 17, stage: fifthStage!),
            (level: "5.19", unlocked: false, completed: false, order: 18, stage: fifthStage!),
            (level: "5.20", unlocked: false, completed: false, order: 19, stage: fifthStage!),
            
            (level: "6.1", unlocked: false, completed: false, order: 0, stage: sixthStage!),
            (level: "6.2", unlocked: false, completed: false, order: 1, stage: sixthStage!),
            (level: "6.3", unlocked: false, completed: false, order: 2, stage: sixthStage!),
            (level: "6.4", unlocked: false, completed: false, order: 3, stage: sixthStage!),
            (level: "6.5", unlocked: false, completed: false, order: 4, stage: sixthStage!),
            (level: "6.6", unlocked: false, completed: false, order: 5, stage: sixthStage!),
            (level: "6.7", unlocked: false, completed: false, order: 6, stage: sixthStage!),
            (level: "6.8", unlocked: false, completed: false, order: 7, stage: sixthStage!),
            (level: "6.9", unlocked: false, completed: false, order: 8, stage: sixthStage!),
            (level: "6.10", unlocked: false, completed: false, order: 9, stage: sixthStage!),
            (level: "6.11", unlocked: false, completed: false, order: 10, stage: sixthStage!),
            (level: "6.12", unlocked: false, completed: false, order: 11, stage: sixthStage!),
            (level: "6.13", unlocked: false, completed: false, order: 12, stage: sixthStage!),
            (level: "6.14", unlocked: false, completed: false, order: 13, stage: sixthStage!),
            (level: "6.15", unlocked: false, completed: false, order: 14, stage: sixthStage!),
            (level: "6.16", unlocked: false, completed: false, order: 15, stage: sixthStage!)
            
        ]
        
        for level in levels {
            Level.addLevel(context, level.level, level.unlocked, level.completed, Int32(level.order), level.stage)
        }
    }
    
    private func seedWorkouts()
    {
        let level1_1 = try! Level.getLevel(context, "1.1")
        let level1_2 = try! Level.getLevel(context, "1.2")
        let level1_3 = try! Level.getLevel(context, "1.3")
        let level1_4 = try! Level.getLevel(context, "1.4")
        let level1_5 = try! Level.getLevel(context, "1.5")
        let level1_6 = try! Level.getLevel(context, "1.6")
        let level1_7 = try! Level.getLevel(context, "1.7")
        let level1_8 = try! Level.getLevel(context, "1.8")
        let level1_9 = try! Level.getLevel(context, "1.9")
        let level1_10 = try! Level.getLevel(context, "1.10")
        
        let level2_1 = try! Level.getLevel(context, "2.1")
        let level2_2 = try! Level.getLevel(context, "2.2")
        let level2_3 = try! Level.getLevel(context, "2.3")
        let level2_4 = try! Level.getLevel(context, "2.4")
        let level2_5 = try! Level.getLevel(context, "2.5")
        let level2_6 = try! Level.getLevel(context, "2.6")
        let level2_7 = try! Level.getLevel(context, "2.7")
        let level2_8 = try! Level.getLevel(context, "2.8")
        let level2_9 = try! Level.getLevel(context, "2.9")
        let level2_10 = try! Level.getLevel(context, "2.10")
        let level2_11 = try! Level.getLevel(context, "2.11")
        let level2_12 = try! Level.getLevel(context, "2.12")
        
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
        let level5_11 = try! Level.getLevel(context, "5.11")
        let level5_12 = try! Level.getLevel(context, "5.12")
        let level5_13 = try! Level.getLevel(context, "5.13")
        let level5_14 = try! Level.getLevel(context, "5.14")
        let level5_15 = try! Level.getLevel(context, "5.15")
        let level5_16 = try! Level.getLevel(context, "5.16")
        let level5_17 = try! Level.getLevel(context, "5.17")
        let level5_18 = try! Level.getLevel(context, "5.18")
        let level5_19 = try! Level.getLevel(context, "5.19")
        let level5_20 = try! Level.getLevel(context, "5.20")
        
        let level6_1 = try! Level.getLevel(context, "6.1")
        let level6_2 = try! Level.getLevel(context, "6.2")
        let level6_3 = try! Level.getLevel(context, "6.3")
        let level6_4 = try! Level.getLevel(context, "6.4")
        let level6_5 = try! Level.getLevel(context, "6.5")
        let level6_6 = try! Level.getLevel(context, "6.6")
        let level6_7 = try! Level.getLevel(context, "6.7")
        let level6_8 = try! Level.getLevel(context, "6.8")
        let level6_9 = try! Level.getLevel(context, "6.9")
        let level6_10 = try! Level.getLevel(context, "6.10")
        let level6_11 = try! Level.getLevel(context, "6.11")
        let level6_12 = try! Level.getLevel(context, "6.12")
        let level6_13 = try! Level.getLevel(context, "6.13")
        let level6_14 = try! Level.getLevel(context, "6.14")
        let level6_15 = try! Level.getLevel(context, "6.15")
        let level6_16 = try! Level.getLevel(context, "6.16")
        
        let workouts = [
            
            /// Build strength with the basic flex
            (repCount: 3, repLength: 2, restLength: 3, level: level1_1),
            (repCount: 4, repLength: 2, restLength: 3, level: level1_2),
            (repCount: 5, repLength: 2, restLength: 3, level: level1_3),
            (repCount: 6, repLength: 2, restLength: 4, level: level1_4),
            (repCount: 7, repLength: 2, restLength: 4, level: level1_5),
            (repCount: 8, repLength: 2, restLength: 4, level: level1_6),
            (repCount: 10, repLength: 2, restLength: 5, level: level1_7),
            (repCount: 8, repLength: 3, restLength: 5, level: level1_8),
            (repCount: 9, repLength: 3, restLength: 5, level: level1_9),
            (repCount: 10, repLength: 3, restLength: 5, level: level1_10),
            
            /// Improve control and stamina
            (repCount: 8, repLength: 1, restLength: 2, level: level2_1),
            (repCount: 10, repLength: 1, restLength: 2, level: level2_2),
            (repCount: 12, repLength: 1, restLength: 3, level: level2_3),
            (repCount: 15, repLength: 1, restLength: 3, level: level2_4),
            (repCount: 20, repLength: 1, restLength: 3, level: level2_5),
            (repCount: 15, repLength: 1, restLength: 2, level: level2_6),
            (repCount: 15, repLength: 1, restLength: 1, level: level2_7),
            (repCount: 18, repLength: 1, restLength: 2, level: level2_8),
            (repCount: 20, repLength: 1, restLength: 2, level: level2_9),
            (repCount: 10, repLength: 4, restLength: 5, level: level2_10),
            (repCount: 10, repLength: 4, restLength: 5, level: level2_11),
            (repCount: 20, repLength: 1, restLength: 1, level: level2_12),
            
            /// Focus on building basic strength, control and stamina
            (repCount: 10, repLength: 4, restLength: 5, level: level3_1),
            (repCount: 8, repLength: 4, restLength: 4, level: level3_2),
            (repCount: 10, repLength: 4, restLength: 4, level: level3_3),
            (repCount: 15, repLength: 1, restLength: 2, level: level3_4),
            (repCount: 8, repLength: 5, restLength: 4, level: level3_5),
            (repCount: 12, repLength: 2, restLength: 3, level: level3_6),
            (repCount: 10, repLength: 2, restLength: 2, level: level3_7),
            (repCount: 9, repLength: 5, restLength: 4, level: level3_8),
            (repCount: 10, repLength: 5, restLength: 4, level: level3_9),
            (repCount: 20, repLength: 1, restLength: 1, level: level3_10),
            (repCount: 10, repLength: 5, restLength: 5, level: level3_11),
            (repCount: 15, repLength: 2, restLength: 2, level: level3_12),
            
            /// Start building longer lasting strength
            (repCount: 12, repLength: 5, restLength: 3, level: level4_1),
            (repCount: 15, repLength: 2, restLength: 2, level: level4_2),
            (repCount: 20, repLength: 2, restLength: 2, level: level4_3),
            (repCount: 5, repLength: 6, restLength: 5, level: level4_4),
            (repCount: 5, repLength: 6, restLength: 4, level: level4_5),
            (repCount: 7, repLength: 5, restLength: 2, level: level4_6),
            (repCount: 8, repLength: 5, restLength: 2, level: level4_7),
            (repCount: 10, repLength: 5, restLength: 2, level: level4_8),
            (repCount: 12, repLength: 2, restLength: 1, level: level4_9),
            (repCount: 6, repLength: 6, restLength: 5, level: level4_10),
            (repCount: 4, repLength: 7, restLength: 5, level: level4_11),
            (repCount: 4, repLength: 7, restLength: 4, level: level4_12),
            (repCount: 5, repLength: 7, restLength: 5, level: level4_13),
            (repCount: 5, repLength: 7, restLength: 5, level: level4_14),
            (repCount: 25, repLength: 1, restLength: 1, level: level4_15),
            
            /// Start utilising the hold
            (repCount: 3, repLength: 8, restLength: 6, level: level5_1),
            (repCount: 3, repLength: 9, restLength: 6, level: level5_2),
            (repCount: 3, repLength: 9, restLength: 5, level: level5_3),
            (repCount: 3, repLength: 10, restLength: 6, level: level5_4),
            (repCount: 3, repLength: 10, restLength: 5, level: level5_5),
            (repCount: 4, repLength: 8, restLength: 6, level: level5_6),
            (repCount: 4, repLength: 10, restLength: 6, level: level5_7),
            (repCount: 4, repLength: 10, restLength: 6, level: level5_8),
            (repCount: 4, repLength: 12, restLength: 6, level: level5_9),
            (repCount: 4, repLength: 12, restLength: 5, level: level5_10),
            (repCount: 4, repLength: 12, restLength: 5, level: level5_11),
            (repCount: 4, repLength: 12, restLength: 4, level: level5_12),
            (repCount: 5, repLength: 9, restLength: 5, level: level5_13),
            (repCount: 5, repLength: 9, restLength: 4, level: level5_14),
            (repCount: 5, repLength: 10, restLength: 4, level: level5_15),
            (repCount: 3, repLength: 15, restLength: 6, level: level5_16),
            (repCount: 3, repLength: 15, restLength: 6, level: level5_17),
            (repCount: 3, repLength: 15, restLength: 5, level: level5_18),
            (repCount: 4, repLength: 15, restLength: 5, level: level5_19),
            (repCount: 4, repLength: 15, restLength: 4, level: level5_20),
            
            /// Begin mixing up differeent session types
            (repCount: 10, repLength: 6, restLength: 6, level: level6_1),
            (repCount: 25, repLength: 1, restLength: 1, level: level6_2),
            (repCount: 20, repLength: 2, restLength: 1, level: level6_3),
            (repCount: 5, repLength: 13, restLength: 6, level: level6_4),
            (repCount: 8, repLength: 5, restLength: 3, level: level6_5),
            (repCount: 13, repLength: 7, restLength: 5, level: level6_6),
            (repCount: 12, repLength: 3, restLength: 2, level: level6_7),
            (repCount: 6, repLength: 8, restLength: 6, level: level6_8),
            (repCount: 6, repLength: 8, restLength: 5, level: level6_9),
            (repCount: 12, repLength: 2, restLength: 1, level: level6_10),
            (repCount: 8, repLength: 5, restLength: 2, level: level6_11),
            (repCount: 3, repLength: 15, restLength: 4, level: level6_12),
            (repCount: 24, repLength: 2, restLength: 2, level: level6_13),
            (repCount: 6, repLength: 9, restLength: 6, level: level6_14),
            (repCount: 7, repLength: 12, restLength: 5, level: level6_15),
            (repCount: 10, repLength: 8, restLength: 6, level: level6_16)
            
        ]
        
        for workout in workouts {
            Workout.addLevelWorkout(context, Int32(workout.repCount), Int32(workout.repLength), Int32(workout.restLength), workout.level!)
        }
    }
}
