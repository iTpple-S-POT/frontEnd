//
//  PersistenceManager.swift
//
//
//  Created by 최준영 on 1/15/24.
//

import CoreData

public protocol PersistenceManager {
    
    var context: NSManagedObjectContext { get }
    
    init(configuration: PersistenceConfiguration, bundleForModelId: Bundle)
}


extension PersistenceManager {
    
    static func model(for name: String, bundle: Bundle) -> NSManagedObjectModel {
        
        let modelURL = bundle.url(forResource: name, withExtension: ".momd")!
        
        let model = NSManagedObjectModel(contentsOf: modelURL)!

        return model
    }
}
