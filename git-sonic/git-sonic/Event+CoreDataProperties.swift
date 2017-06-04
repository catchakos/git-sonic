//
//  Event+CoreDataProperties.swift
//  git-sonic
//
//  Created by Alexandros Katsaprakakis on 04/06/2017.
//  Copyright © 2017 phonegroove. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var timeStamp: NSDate?

}
