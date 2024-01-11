//
//  SpotPotCategoryModel.swift
//
//
//  Created by 최준영 on 2024/01/04.
//

import Foundation

struct SpotPotCategoryModel: Decodable {
    
    var categoryList: [PotCategory]
    
}

public struct PotCategory: Decodable {
    
    var id: Int
    var name: String
    var description: String
    
}
