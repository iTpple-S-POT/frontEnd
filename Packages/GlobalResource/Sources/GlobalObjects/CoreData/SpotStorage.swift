//
//  CoreDataManager.swift
//
//
//  Created by 최준영 on 1/15/24.
//

import Foundation
import Persistence

public struct SpotStorage {
    
    static public var `default` = SpotStorage()
    
    private init() { }
    
    public var mainStorageManager = SpotStorageManager(configuration: PersistenceConfiguration(modelName: "SpotModel"))
    
}


