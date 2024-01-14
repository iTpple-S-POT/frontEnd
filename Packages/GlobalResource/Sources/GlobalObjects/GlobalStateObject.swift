//
//  FilGlobalStateObjecte.swift
//
//
//  Created by 최준영 on 2024/01/12.
//

import SwiftUI

public enum LocalDataError: Error {
    
    case dataNotFoundInLocal(name: String)
    
}

public class GlobalStateObject: ObservableObject {
    
    public private(set) var categories: [CategoryObject]!
    
    public init() { }
    
    public func setCategories(categories: [CategoryObject]) {
        
        self.categories = categories
    }
    
    // UserDefaults key
    let kPotCategory = "spotPotCategory"
    

    public func intialDataTask() async throws {
        
        var categories: [CategoryObject]!
        
        if let localData = try? checkCategoriesExistsInUserDefaults() {
            
            print("카테고리를 로컬에서 가져옴")
            
            categories = localData
            
        } else {
            
            let serverData = try await APIRequestGlobalObject.shared.getCategoryFromServer()
            
            print("카테고리: 서버에서 가져오기 성공")
            
            categories = serverData
        }
        
        try saveCategoryToLocal(objects: categories!)
        
        print("카테고리 로컬에 저장 성공")
        
        setCategories(categories: categories)
    }
}

// MARK: - 팟 카테고리
public extension GlobalStateObject {
    
    // 서버로 부터 카테고리를 업로드
    private func getCategoryFromServer() async throws -> [CategoryObject] {
        
        try await APIRequestGlobalObject.shared.getCategoryFromServer()
    }
    
    // 로컬에 카테고리 저장
    private func saveCategoryToLocal(objects: [CategoryObject]) throws {
        
        let econded = try JSONEncoder().encode(objects)
        
        UserDefaults.standard.set(econded, forKey: self.kPotCategory)
        
    }
    
    // 로컬 카테고리 존재 확인
    private func checkCategoriesExistsInUserDefaults() throws -> [CategoryObject] {
        
        if let data = UserDefaults.standard.data(forKey: self.kPotCategory), let decoded = try? JSONDecoder().decode([CategoryObject].self, from: data) {
            
            return decoded
        }
        
        throw LocalDataError.dataNotFoundInLocal(name: "Category")
    }
}
