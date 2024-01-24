//
//  File.swift
//  
//
//  Created by 최준영 on 1/22/24.
//

import Foundation

struct PotsResponseModel: Decodable {
    let id, userID: Int64
    let categoryID: [Int64]
    let potType, content: String
    let location: Location
    let imageKey, expiredAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case categoryID = "categoryId"
        case potType, content, location, imageKey, expiredAt
    }
}

public struct PotObject {
    
    /// 팟 식별자
    public let id: Int64
    /// 팟을 업로드한 유저 식별자
    public let userId: Int64
    public let categoryId: Int64
    public let content: String
    public let imageKey: String
    public let expirationDate: String
    public let latitude: Double
    public let longitude: Double
    
    public init(id: Int64, userId: Int64, categoryId: Int64, content: String, imageKey: String, expirationDate: String, latitude: Double, longitude: Double) {
        self.id = id
        self.userId = userId
        self.categoryId = categoryId
        self.content = content
        self.imageKey = imageKey
        self.expirationDate = expirationDate
        self.latitude = latitude
        self.longitude = longitude
    }
}
