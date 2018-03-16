//
//  NSManagedObjectHelper.swift
//  JPulikkottil
//
//  Created by Admin on 23/10/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//https://developer.apple.com/library/content/releasenotes/General/WhatNewCoreData2016/ReleaseNotes.html
import Foundation
import CoreData

protocol NSManagedObjectHelper {
}
extension NSManagedObject: NSManagedObjectHelper {
}
extension NSManagedObjectHelper where Self: NSManagedObject {
    
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
    
    static func removeAllObjectsInContext(_ managedContext: NSManagedObjectContext, clearFromMemory: Bool = true) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            /* to clear objects in memory ..  first make sure the resultType of the NSBatchDeleteRequest is set to NSBatchDeleteRequestResultType.resultTypeObjectIDs before the request is executed*/
            if clearFromMemory {
                deleteRequest.resultType = .resultTypeObjectIDs
            }
            let result = try managedContext.execute(deleteRequest) as? NSBatchDeleteResult
            printDebug("\(String(describing: self)) result?")
            if let objectIDArray = result?.result as? [NSManagedObjectID], objectIDArray.count > 0 {
                printDebug("items to delete exist \(objectIDArray)")
                let changes = [NSDeletedObjectsKey: objectIDArray]
                /*to clear objects in memory .. By calling mergeChangesFromRemoteContextSave, all of the NSManagedObjectContext instances that are referenced will be notified that the list of entities referenced with the NSManagedObjectID array have been deleted and that the objects in memory are stale. This causes the referenced NSManagedObjectContext instances to remove any objects in memory that are loaded which match the NSManagedObjectID instances in the array.*/
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [managedContext])
            }
            try managedContext.save()
        } catch let error {
            printError(error)
        }
    }
}

