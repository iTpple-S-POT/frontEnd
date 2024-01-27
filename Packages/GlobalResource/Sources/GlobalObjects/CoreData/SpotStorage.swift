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
    
    let localImageUrl: URL
    
    private init() {
        
        let appDirec = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        self.localImageUrl = appDirec
            .appendingPathComponent("Local")
            .appendingPathComponent("PotImage")
        
        do {
            // 아까 만든 디렉토리 경로에 디렉토리 생성 (폴더가 만들어진다.)
            try FileManager.default.createDirectory(at: localImageUrl, withIntermediateDirectories: true, attributes: nil)
        } catch let e {
            print(e.localizedDescription)
        }
        
    }
    
    public var mainStorageManager = SpotStorageManager(configuration: PersistenceConfiguration(modelName: "SpotModel"))
    
}


