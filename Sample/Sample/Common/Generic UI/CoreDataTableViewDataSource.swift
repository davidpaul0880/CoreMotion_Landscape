//
//  CoreDataTableViewDataSource.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 17/08/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataCellConfigurable: class {
    associatedtype Controller: NSManagedObject
    var cellController: Controller? { get set }
    var cellItemTapped: ((Controller, Int) -> Void)? {get set}
    var tappedIndexPath: IndexPath? {get set}
    func configureCellAtIndexPath(indexPath: IndexPath)
}
extension CoreDataCellConfigurable {
    func configureCellAtIndexPath(indexPath: IndexPath) {}
    var cellItemTapped: ((Controller, Int) -> Void)? {
        get {
            return nil
        }
        set {
            printDebug("default cellItemTapped")
        }
    }
    var tappedIndexPath: IndexPath? {
        get {
            return nil
        }
        set {
            printDebug("default tappedIndexPath")
        }
    }
}
final class CoreDataTableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: CoreDataCellConfigurable, Model == Cell.Controller { //Cell: Reusable, 

    var fetchedResultsController: NSFetchedResultsController<Model>?
    var actionHandler: ((Model, IndexPath) -> Void)?
    var cellSubViewTapped: ((Model, Int) -> Void)?
    var startToScroll: (() -> Void)?
    var endToScrollTop: (() -> Void)?
    var lastContentOffset = CGPoint.zero
    var isTopViewHidden = false
    fileprivate unowned var tableView: UITableView

    init(tableView: UITableView, hideFooter: Bool = true) {
        self.tableView = tableView
        if hideFooter {
            tableView.tableFooterView = UIView()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController?.sections![section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(indexPath: indexPath)
        if let buttonTapped = cellSubViewTapped {

            cell.cellItemTapped = buttonTapped
            cell.tappedIndexPath = indexPath
        }

        cell.cellController = fetchedResultsController?.object(at: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let obj = fetchedResultsController?.object(at: indexPath) {
            actionHandler?(obj, indexPath)
        }
    }
    deinit {
        printDebug("\(String(describing: self)) is being deInitialized.")
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = fetchedResultsController.managedObjectContext
//            context.delete(fetchedResultsController.object(at: indexPath))
//            
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}
