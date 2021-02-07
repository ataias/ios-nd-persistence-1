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
            self.autoSaveViewContext(interval: 3)
            completion?()
        }
    }
}

extension DataController {
    // this helps to save data before an app crashes, when it might not call an explicit save
    func autoSaveViewContext(interval: TimeInterval = 15) {
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        // if you use a timer instead you can stop this auto save afterwards
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {

            self.autoSaveViewContext(interval: interval)
        }
    }
}
