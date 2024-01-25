//
//  File.swift
//
//
//  Created by 최준영 on 1/22/24.
//

import Foundation

public extension SpotStorage {
    
    func filteringLocalPots() async throws {
        
        try await MainActor.run {
            
            let context = self.mainStorageManager.context
            
            let request = Pot.fetchRequest()
            
            request.predicate = NSPredicate(format: "expirationDate < %@", Date() as NSDate)
            
            let willDeletedPots = try context.fetch(request)
            
            print("삭제예정 팟 개수: \(willDeletedPots.count)")
            
            willDeletedPots.forEach {
                
                print($0.expirationDate!)
                
                context.delete($0)
            }
            
            try context.save()
            
        }
        
    }
    
    func insertPots(objects: [PotObject]) async throws {
        
        try await MainActor.run {
            
            let context = self.mainStorageManager.context
            
            let prevObjects = try mainStorageManager.context.fetch(Pot.fetchRequest())
            
            objects.forEach { object in
                
                var isAlreadyExists = false
                
                for prevObject in prevObjects {
                    
                    if object.id == prevObject.id {
                        
                        isAlreadyExists = true
                        
                        // 기존의 오브젝트를 업데이트
                        potFromPotPbject(pot: prevObject, potObject: object)
                        
                        break
                    }
                    
                }
                
                if !isAlreadyExists {
                    
                    // 새로운 엔티티 인스턴스를 생성
                    potFromPotPbject(pot: Pot(context: context), potObject: object)
                }
                
            }
            
            try context.save()
        }
        
    }
    
    func potFromPotPbject(pot: Pot, potObject: PotObject) {
        
        // 기존의 오브젝트를 업데이트
        pot.id = potObject.id
        pot.userId = potObject.userId
        pot.categoryId = potObject.categoryId
        pot.content = potObject.content
        pot.isActive = true
        
        // 만기날짜를 Date로 다시변경
        let expirationDateString = potObject.expirationDate
        
        pot.expirationDate = ISO8601DateFormatter().date(from: expirationDateString)
        pot.latitude = potObject.latitude
        pot.longitude = potObject.longitude
        pot.imageKey = potObject.imageKey
    }
    
}


// MARK: - 더미 팟
public extension SpotStorage {
    
    func makeDummyPot(object: SpotPotUploadObject) async {
        
        await MainActor.run {
            
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
    }
    
    
    private static let dummyPotId: Int64 = -12345
    
    func updateDummyPot(object: PotObject) async throws {
        
        try await MainActor.run {
            
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
    }
    
    func deleteDummyPot() async throws {
        
        try await MainActor.run {
            
            let context = self.mainStorageManager.context
            
            let request = Pot.fetchRequest()
            
            request.predicate = NSPredicate(format: "id == %d", Self.dummyPotId)
            
            let dummyObject = try context.fetch(request).first!
            
            context.delete(dummyObject)
        }
    }
}
