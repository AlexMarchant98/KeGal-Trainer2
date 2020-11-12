//
//  Stage.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/04/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class Stage: NSManagedObject {
    
    class func getAllStages(_ context: NSManagedObjectContext) throws -> [Stage]?
    {
        let request: NSFetchRequest<Stage> = Stage.fetchRequest()
        do {
            if let stages = try context.fetch(request) as [Stage]?
            {
                return stages
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func getStageByStageNumber(_ context: NSManagedObjectContext, _ stage: Int32) throws -> Stage?
    {
        let request: NSFetchRequest<Stage> = Stage.fetchRequest()
        request.predicate = NSPredicate(format: "stage = %@ ", String(stage) as CVarArg)
        do {
            if let stage = try context.fetch(request).first
            {
                return stage
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func addStage(_ context: NSManagedObjectContext, _ stage: Int32, _ unlocked: Bool, _ completed: Bool)
    {
        let newStage = Stage(context: context)
        newStage.stage = stage
        newStage.unlocked = unlocked
        newStage.completed = completed
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
    
    class func unlockNextStage(_ context: NSManagedObjectContext, _ currentStage: Int32) -> Stage?
    {
        do {
            let stage = try getStageByStageNumber(context, currentStage)
            stage?.completed = true
            
            let nextStage = try getStageByStageNumber(context, currentStage + 1)
            nextStage?.unlocked = true
            
            return nextStage
        } catch {
            return nil
        }
    }
}
