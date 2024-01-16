//
//  PersistenceConfiguration.swift
//
//
//  Created by 최준영 on 1/15/24.
//

import Foundation

public struct PersistenceConfiguration {
    
    public let modelName: String
    public let cloudIdentifier: String
    public let isInMemory: Bool
    
    public init(modelName: String, cloudIdentifier: String = "", isInMemory: Bool = false) {
        self.modelName = modelName
        self.cloudIdentifier = cloudIdentifier
        self.isInMemory = isInMemory
    }
}
