//
//  File.swift
//
//
//  Created by 최준영 on 1/22/24.
//

import Foundation
import CoreData

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
    
    @MainActor
    func insertServerPots(objects: [PotObject]) async throws {
        
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
            
            if !isAlreadyExists, let key = object.imageKey {
                
                let pot = Pot(context: context)
                
                let urlString = "https://d1gmn3m06z496v.cloudfront.net/" + key
                
                print(urlString)
                
                let url = URL(string: urlString)!
                
                let request = URLRequest(url: url)
                
                URLSession.shared.dataTask(with: request) { data, res, error in
                    
                    let desUrl = makeImageUrlFrom(id: object.id)
                    
                    DispatchQueue.main.async {
                        do {
                            
                            if let imageData = data {
                                
                                pot.imageURL = try saveDataToLocal(id: object.id, data: imageData)
                            }
                            
                            try context.save()
                        } catch {
                            print("팟이미지 불러오기 실패")
                        }
                    }
                    
                }.resume()
                
                // 새로운 엔티티 인스턴스를 생성
                potFromPotPbject(pot: pot, potObject: object)
            }
            
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
    
    @MainActor
    func makeDummyPot(object: SpotPotUploadObject, imageData: Data) async throws {
        
        let context = self.mainStorageManager.context
        
        let dummyPotObject = Pot(context: context)
        
        dummyPotObject.id = Self.dummyPotId
        dummyPotObject.categoryId = object.category
        dummyPotObject.content = object.text
        dummyPotObject.latitude = object.latitude
        dummyPotObject.longitude = object.longitude
        dummyPotObject.isActive = false
        dummyPotObject.expirationDate = Date.now + 86400
        dummyPotObject.imageURL = try saveDataToLocal(id: Self.dummyPotId, data: imageData)
    }
    
    private func saveDataToLocal(id: Int64, data: Data) throws -> URL {
        
        let fileUrl = makeImageUrlFrom(id: id)
        
        try data.write(to: fileUrl)
        
        return fileUrl
    }
    
    
    private static let dummyPotId: Int64 = -12345
    
    @MainActor
    func updateDummyPot(object: PotObject) async throws {
        
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
        
        let dummyUrl = dummyObject.imageURL!
        
        let fileUrl = makeImageUrlFrom(id: object.id)
        
        try FileManager.default.moveItem(at: dummyUrl, to: fileUrl)
        
        dummyObject.imageURL = fileUrl
        
        try context.save()
    }
    
    @MainActor
    func deleteDummyPot() async throws {
        
        let context = self.mainStorageManager.context
        
        let request = Pot.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", Self.dummyPotId)
        
        let dummyObject = try context.fetch(request).first!
        
        context.delete(dummyObject)
    }
    
    func saveImageTo(id: Int64, data: Data) throws {
        
        let context = self.mainStorageManager.container.newBackgroundContext()
        
        let request = Pot.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", id)
        
        let pot = try context.fetch(request).first!
        
        let imageUrl = makeImageUrlFrom(id: id)
        
        FileManager.default.createFile(atPath: imageUrl.absoluteString, contents: data)
        
        pot.imageURL = imageUrl
        
        try context.save()
    }
    
    func makeImageUrlFrom(id: Int64) -> URL {
        
        return localImageUrl.appendingPathComponent("pot\(id)image", conformingTo: .png)
    }
 }
