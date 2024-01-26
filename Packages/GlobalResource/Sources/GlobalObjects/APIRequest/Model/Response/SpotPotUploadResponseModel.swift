//
//  File.swift
//  
//
//  Created by 최준영 on 2024/01/08.
//

import Foundation

// MARK: - pot response
struct SpotPotUploadResponseModel: Codable {
    let id, userID, categoryID: Int64
    let type, imageKey: String
    let content: String?
    let location: Location
    let expiredAt, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case categoryID = "categoryId"
        case type, content, imageKey, location, expiredAt, createdAt
    }
}


