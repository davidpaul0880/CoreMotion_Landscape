//
//  NSManagedObjectHelper.swift
//  BitReel
//
//  Created by Admin on 23/10/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import CoreData

protocol NSManagedObjectHelper {
}
extension NSManagedObject: NSManagedObjectHelper {
}
extension NSManagedObjectHelper where Self: NSManagedObject {
    static func createObjectInMainThread() -> Self? {
        let managedContext = ZcoCoreDataHelper.sharedInstance.persistentContainer.viewContext
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into: managedContext) as? Self
    }
    static func fetchObjects(sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) -> [Self]? {
        
        var objs: [Self]?
        ZcoCoreDataHelper.sharedInstance.performForegroundSyncTask { (context) in
            let employeesFetch: NSFetchRequest<Self> = NSFetchRequest(entityName: String(describing: self))
            employeesFetch.sortDescriptors = sortDescriptors
            employeesFetch.predicate = predicate
            do {
                objs = try context.fetch(employeesFetch)
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }
        }
        return objs
    }
    static func fetchObjects(sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [Self]? {
        
        var objs: [Self]?
        let employeesFetch: NSFetchRequest<Self> = NSFetchRequest(entityName: String(describing: self))
        employeesFetch.sortDescriptors = sortDescriptors
        employeesFetch.predicate = predicate
        do {
            objs = try context.fetch(employeesFetch)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return objs
    }

    static func removeAllObjects() {
        let managedContext = ZcoCoreDataHelper.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = Self.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            printError(error)
        }
    }
    static func removeAllObjects(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = Self.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            printError(error)
        }
    }
    func delete() {
        let managedContext = ZcoCoreDataHelper.sharedInstance.persistentContainer.viewContext
        managedContext.delete(self)
    }
}
