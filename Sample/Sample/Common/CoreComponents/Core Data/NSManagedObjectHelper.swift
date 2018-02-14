//
//  NSManagedObjectHelper.swift
//  JPulikkottil
//
//  Created by Admin on 23/10/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

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

    static func removeAllObjectsInContext(_ managedContext: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = Self.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            printError(error)
        }
    }
}
