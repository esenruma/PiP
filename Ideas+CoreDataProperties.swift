//
//  Ideas+CoreDataProperties.swift
//  PiP
//
//  Created by Roma on 08/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ideas {

    @NSManaged var notes: String?
    @NSManaged var photo: NSData?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var email: String?
    @NSManaged var telephone: String?

}
