//
//  NSEntityMigrationPolicy.swift
//  Mooskine
//
//  Created by Ataias Pereira Reis on 09/02/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import UIKit
import CoreData

class UpdateToAttributedStringsPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource source: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {

        try super.createDestinationInstances(forSource: source, in: mapping, manager: manager)

        guard let destination = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [source]).first else {
            return
        }

        if let text = source.value(forKey: "text") as? String {
            destination.setValue(NSAttributedString(string: text), forKey: "attributedText")
        }
    }
}
