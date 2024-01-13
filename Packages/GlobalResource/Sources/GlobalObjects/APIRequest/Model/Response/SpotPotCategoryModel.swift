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

public struct CategoryObject: Codable {
    
    var id: Int64
    var name: String
    var description: String
    
}
