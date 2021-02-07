//
//  Notebook+extensions.swift
//  Mooskine
//
//  Created by Ataias Pereira Reis on 07/02/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
