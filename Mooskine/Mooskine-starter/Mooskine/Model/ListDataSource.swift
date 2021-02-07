//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Ataias Pereira Reis on 07/02/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell & Cell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var tableView: UITableView
    var managedObjectContext: NSManagedObjectContext
    var fetchRequest: NSFetchRequest<ObjectType>
    var fetchedResultsController: NSFetchedResultsController<ObjectType>
    let configure: (CellType, ObjectType) -> Void

    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ObjectType>, configure: @escaping (CellType, ObjectType) -> Void) {
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.fetchRequest = fetchRequest
        self.configure = configure
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        self.tableView.dataSource = self
        self.fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be executed: \(error.localizedDescription)")
        }


    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.defaultReuseIdentifier, for: indexPath) as! CellType

        configure(cell, object)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    public func delete(at indexPath: IndexPath) {
        let objectToDelete = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(objectToDelete)
        try? managedObjectContext.save()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delete(at: indexPath)
        default: () // Unsupported
        }
    }


    // MARK: NSFetchResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)

        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}

