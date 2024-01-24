import CoreData
import Foundation

open class LocalPersistenceManager: PersistenceManager {
    
    public var context: NSManagedObjectContext { container.viewContext }
    
    public let container: PersistentContainer!
    
    public required init(configuration: PersistenceConfiguration, bundleForModelId: Bundle) {
        
        let model = Self.model(for: configuration.modelName, bundle: bundleForModelId)
        
        self.container = .init(name: configuration.modelName, managedObjectModel: model)
        
        if configuration.isInMemory {
            self.container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        self.container.loadPersistentStores { (desc, error) in
            
            if let _ = error {
                
                fatalError("Store로딩 실패")
            }
            
            print("저장소 로딩 성공")
        }
        
    }
    	
}
