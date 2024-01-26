//
//  File.swift
//  
//
//  Created by 최준영 on 1/18/24.
//

import CoreData

extension SpotStorageManager {
    
    public enum SpotStorageEntityType {
        
        case spotCategory
        
        func getEntityName() -> String {
            
            switch self {
            case .spotCategory:
                return "SpotCategory"
            default:
                fatalError("처리되지 못한 엔티티")
            }
            
        }
        
    }
    
    /// Factory 패턴
    /// 데이터 읽기 or 데이터 존재 여부 확인
    func fetchObjectsFromMainStorage<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) throws -> [T] {
        
        let context = context
        
        let request = T.fetchRequest()
        
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        
        let objects = try context.fetch(request) as! [T]
        
        return objects
    }
}
