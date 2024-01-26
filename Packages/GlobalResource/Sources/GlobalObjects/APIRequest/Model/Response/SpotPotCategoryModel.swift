//
//  SpotPotCategoryModel.swift
//
//
//  Created by 최준영 on 2024/01/04.
//

import Foundation

struct PotCategoryModel: Decodable {
    
    var categoryList: [CategoryModel]
    
}

struct CategoryModel: Decodable {
    var id: Int64
    var name: String
    var description: String
}

public struct CategoryObject: Codable, Hashable {
    
    public var id: Int64
    public var name: String
    public var description: String
    
    public init(id: Int64, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
}
