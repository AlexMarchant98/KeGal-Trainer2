//
//  Level.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/04/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import CoreData

class Level: NSManagedObject {
    
    class func getLevel(_ context: NSManagedObjectContext, _ level: String) throws -> Level?
    {
        let request: NSFetchRequest<Level> = Level.fetchRequest()
        request.predicate = NSPredicate(format: "level = %@ ", level as CVarArg)
        do {
            if let level = try context.fetch(request).first
            {
                return level
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func getLevelsByStage(_ context: NSManagedObjectContext, _ stage: Int32) throws -> [Level]?
    {
        let request: NSFetchRequest<Level> = Level.fetchRequest()
        request.predicate = NSPredicate(format: "stage = %ld ", stage as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Level.order), ascending: true)
        request.sortDescriptors = [sort]
        do {
            if let levels = try context.fetch(request)  as [Level]?
            {
                return levels
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func getLevelByOrder(_ context: NSManagedObjectContext, _ stage: Int, _ order: Int) throws -> Level?
    {
        let request: NSFetchRequest<Level> = Level.fetchRequest()
        request.predicate = NSPredicate(format: "stage = %ld AND order = %ld", Int32(stage), Int32(order) as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Level.order), ascending: true)
        request.sortDescriptors = [sort]
        do {
            if let level = try context.fetch(request).first
            {
                return level
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    class func unlockFirstLevelOfStage(_ context: NSManagedObjectContext, _ stage: Int32) throws
    {
        let request: NSFetchRequest<Level> = Level.fetchRequest()
        request.predicate = NSPredicate(format: "stage = %ld ", stage as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Level.order), ascending: true)
        request.sortDescriptors = [sort]
        do {
            if let level = try context.fetch(request).first as Level?
            {
                level.unlocked = true
            }
        } catch {
            throw error
        }
        
        saveContext(context)
    }
    
    class func addLevel(_ context: NSManagedObjectContext, _ level: String, _ unlocked: Bool, _ completed: Bool, _ order: Int32, _ stage: Stage)
    {
        let newLevel = Level(context: context)
        newLevel.level = level
        newLevel.unlocked = unlocked
        newLevel.completed = completed
        newLevel.order = order
        newLevel.stage = stage
        
        saveContext(context)
    }
    
    class func completeLevel(_ context: NSManagedObjectContext, _ level: String)
    {
        do {
            let completedLevel = try getLevel(context, level)
            completedLevel?.completed = true
        } catch {
            print("Could not update the level \(level)")
        }
        
        saveContext(context)
    }
    
    class func unlockNextLevel(_ context: NSManagedObjectContext, _ stage: Int32, currentLevelOrder: Int32) -> Level?
    {
        let request: NSFetchRequest<Level> = Level.fetchRequest()
        request.predicate = NSPredicate(format: "stage = %ld", stage as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Level.order), ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            if let level = try context.fetch(request).first(where: { $0.order == currentLevelOrder + 1 }) as Level?
            {
                level.unlocked = true
                
                saveContext(context)
                
                return level
            }
        } catch {
            // print/log an error
        }
        
        return nil
    }
    
    class func saveContext(_ context: NSManagedObjectContext)
    {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Something went wrong whilst saving the entity")
        }
    }
}
