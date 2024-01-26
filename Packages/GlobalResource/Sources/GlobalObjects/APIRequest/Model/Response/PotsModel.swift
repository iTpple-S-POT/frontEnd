//
//  File.swift
//  
//
//  Created by 최준영 on 1/22/24.
//

import Foundation

struct PotsResponseModel: Decodable {
    let id, userId: Int64
    let categoryId: [Int64]
    let potType: String
    let content: String?
    let location: Location
    let imageKey, expiredAt: String
    let hashtagList: [String]
    let viewCount: Int64
}

public struct PotObject {
    
    /// 팟 식별자
    public let id: Int64
    /// 팟을 업로드한 유저 식별자
    public let userId: Int64
    public let categoryId: Int64
    public let content: String
    public let imageKey: String?
    public let expirationDate: String
    public let latitude: Double
    public let longitude: Double
    
    public init(id: Int64, userId: Int64, categoryId: Int64, content: String, imageKey: String?, expirationDate: String, latitude: Double, longitude: Double) {
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
