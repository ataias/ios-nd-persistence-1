//
//  Note+Extensions.swift
//  Mooskine
//
//  Created by Ataias Pereira Reis on 07/02/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
