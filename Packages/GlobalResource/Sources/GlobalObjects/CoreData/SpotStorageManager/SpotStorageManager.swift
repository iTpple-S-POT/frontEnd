//
//  SpotStorageManager.swift
//
//
//  Created by 최준영 on 1/18/24.
//

import Persistence
import CoreData

public final class SpotStorageManager: LocalPersistenceManager {
    
    required init(configuration: PersistenceConfiguration, bundleForModelId: Bundle) {
        super.init(configuration: configuration, bundleForModelId: .module)
        
        // 병합 정책 지정
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    convenience public required init(configuration: PersistenceConfiguration) {
        self.init(configuration: configuration, bundleForModelId: .module)
    }
    
}
