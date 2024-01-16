//
//  PersistentContainer.swift
//
//
//  Created by 최준영 on 1/15/24.
//

import CoreData


open class PersistentContainer: NSPersistentContainer {

    override open class func defaultDirectoryURL() -> URL {

        return super.defaultDirectoryURL()
            .appendingPathComponent("CoreDataModel")
            .appendingPathComponent("Local")
    }
}
