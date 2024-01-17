//
//  CoreDataManager.swift
//
//
//  Created by 최준영 on 1/15/24.
//

import CoreData
import Foundation
import Persistence

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

public struct SpotStorage {
    
    static public var `default` = SpotStorage()
    
    private init() { }
    
    public var mainStorageManager = SpotStorageManager(configuration: PersistenceConfiguration(modelName: "SpotModel"))
    
}

public extension SpotStorage {
    
    enum SpotStorageEntityType {
        
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
    
    func loadCategories() async throws {
        
        // 로컬에 저장된 카테고리가 있음, 저장된 것이 없는 경우 빈배열을 반환함
        let categories: [SpotCategory] = try fetchObjectsFromMainStorage()
        if categories.isEmpty {
            
            print("로컬에 저장된 카테고리가 있음")
            
            // 백그라운드에서 서버값과 비교후 다를 시 업데이트
            Task.detached {
                
                let categoriesFromSever = try await APIRequestGlobalObject.shared.getCategoryFromServer()
                
                try self.updateCategories(newCategories: categoriesFromSever)
            }
            
        } else {
            
            let categoriesFromSever = try await APIRequestGlobalObject.shared.getCategoryFromServer()
            
            // TODO: 다른 데이터 생길경우 배치처리
            try self.insetCategoriesToMainStorage(categories: categoriesFromSever, immediateSave: true)
        }
    }
    
    /// Factory 패턴
    /// 데이터 읽기 or 데이터 존재 여부 확인
    private func fetchObjectsFromMainStorage<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) throws -> [T] {
        
        let context = mainStorageManager.context
        
        let request = T.fetchRequest()
        
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        
        let objects = try context.fetch(request) as! [T]
        
        return objects
    }
    
    func insetCategoriesToMainStorage(categories: [CategoryObject], immediateSave: Bool = false) throws {
        
        let context = mainStorageManager.context
        
        categories.forEach {
            
            let category = SpotCategory(context: context)
            
            category.id = $0.id
            category.name = $0.name
            category.content = $0.description
        }
        
        if immediateSave {
            
            try context.save()
        }
    }
    
    /// 로컬에 존재하는 경우에만 업데이트
    func updateCategories(newCategories: [CategoryObject]) throws {
        
        let context = mainStorageManager.context
        
        let sortedOldCategories: [SpotCategory] = try fetchObjectsFromMainStorage(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
        
        // 저장된 것이 없는 경우, 업데이트할 것이 없음으로 내용을 그대로 저장소에 저장
        if sortedOldCategories.isEmpty {
            
            try insetCategoriesToMainStorage(categories: newCategories, immediateSave: true)
            
            return
        }
        
        let sortedNewCategories = newCategories.sorted { $0.id < $1.id }
        
        for index in 0..<sortedNewCategories.count {
            sortedOldCategories[index].id = sortedNewCategories[index].id
            sortedOldCategories[index].name = sortedNewCategories[index].name
            sortedOldCategories[index].content = sortedNewCategories[index].description
        }
        
        // 변동사항이 있는 경우 업데이트, 백그라운드 실행
        if context.hasChanges {
            
            Task.detached {
                
                try? await mainStorageManager.container.performBackgroundTask { context in
                    
                    
                    try context.save()
                    
                    print("메인 저장소 저장 성공")
                }
            }
        }
    }
}
