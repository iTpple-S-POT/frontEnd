//
//  File.swift
//  
//
//  Created by 최준영 on 1/22/24.
//

import Foundation

public extension SpotStorage {
    
    func filteringLocalPots() async throws {
        
        let context = self.mainStorageManager.context
        
        try context.performAndWait {
            
            let request = Pot.fetchRequest()
            
            request.predicate = NSPredicate(format: "expirationDate < %@", Date() as NSDate)
            
            let willDeletedPots = try context.fetch(request)
            
            willDeletedPots.forEach {
                context.delete($0)
            }
            
            try context.save()
        }
        
    }
    
    func insertPots(objects: [PotObject]) async throws {
        
        let context = self.mainStorageManager.context
        
        try context.performAndWait {
            objects.forEach { object in
                
                let newPotObject = Pot(context: context)
                
                newPotObject.id = object.id
                newPotObject.userId = object.userId
                newPotObject.categoryId = object.categoryId
                newPotObject.content = object.content
                newPotObject.isActive = true
                
                // 만기날짜를 Date로 다시변경
                let expirationDateString = object.expirationDate
                
                newPotObject.expirationDate = DateFormatter().date(from: expirationDateString)
                newPotObject.latitude = object.latitude
                newPotObject.longitude = object.longitude
                newPotObject.imageKey = object.imageKey
                
            }
            
            try context.save()
        }
        
    }
    
}


// MARK: - 더미 팟
public extension SpotStorage {
    
    func makeDummyPot(object: SpotPotUploadObject) {
        
        let context = self.mainStorageManager.context
        
        let dummyPotObject = Pot(context: context)
        
        dummyPotObject.id = Self.dummyPotId
        dummyPotObject.categoryId = object.category
        dummyPotObject.content = object.text
        dummyPotObject.latitude = object.latitude
        dummyPotObject.longitude = object.longitude
        dummyPotObject.isActive = false
        dummyPotObject.expirationDate = Date.now + 86400
    }
    
    
    private static let dummyPotId: Int64 = -12345
    
    func updateDummyPot(object: PotObject) throws {
        
        let context = self.mainStorageManager.context
        
        let request = Pot.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", Self.dummyPotId)
        
        let fetchResult = try context.fetch(request)
        
        print("dummy오브젝트 서칭결과: ", fetchResult.count)
        
        let dummyObject = fetchResult.first!
        
        dummyObject.id = object.id
        dummyObject.userId = object.userId
        dummyObject.categoryId = object.categoryId
        dummyObject.content = object.content
        dummyObject.isActive = true
        
        // 만기날짜를 Date로 다시변경
        let expirationDateString = object.expirationDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        dummyObject.expirationDate = dateFormatter.date(from: expirationDateString)
        dummyObject.latitude = object.latitude
        dummyObject.longitude = object.longitude
        dummyObject.imageKey = object.imageKey
        
        try context.save()
    }
    
    func deleteDummyPot() throws {
        
        let context = self.mainStorageManager.context
        
        let request = Pot.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", Self.dummyPotId)
        
        let dummyObject = try context.fetch(request).first!
        
        context.delete(dummyObject)
    }
}
