//
//  DataController.swift
//  Mooskine
//
//  Created by Ataias Pereira Reis on 07/02/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            completion?()
        }
    }
}

//extension NSManagedObjectContext {
//    /// Wrap a check to `hasChanges` and then `save` for an [NSManagedObjectContext](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext)
//    func save() throws {
//        // TODO how to handle save errors here? maybe use result instead of throws and any caller just gets the error message? it would have to always parse both in a switch...
//        if self.hasChanges {
//            try self.save()
//        }
//    }
//}
