//
//  File.swift
//  
//
//  Created by 최준영 on 1/22/24.
//

import Foundation

public struct PotsResponseModel: Decodable {
    
    public let id, userId: Int64
    public let categoryId: [Int64]
    public let potType: String
    public let content: String?
    public let location: Location
    public let imageKey, expiredAt: String
    public let hashtagList: [HashTagDTO]
    public let viewCount: Int64
    public let reactionTypeCounts: [ReactionCountDTO]?
}

public struct ReactionCountDTO: Decodable {
    
    public var count: Int32
    public let reactionType: String
    
    public init(count: Int32, reactionType: String) {
        self.count = count
        self.reactionType = reactionType
    }
}

public struct PotObject: Hashable {
    
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
    public let hashtagList: [HashTagDTO]
    public var viewCount: Int
    public let reactionTypeCounts: [ReactionCountDTO]
    
    public init(
        id: Int64,
        userId: Int64,
        categoryId: Int64,
        content: String,
        imageKey: String?,
        expirationDate: String,
        latitude: Double,
        longitude: Double,
        hashTagList: [HashTagDTO]=[],
        viewCount: Int=0,
        reactionTypeCounts: [ReactionCountDTO]=[]) {
        self.id = id
        self.userId = userId
        self.categoryId = categoryId
        self.content = content
        self.imageKey = imageKey
        self.expirationDate = expirationDate
        self.latitude = latitude
        self.longitude = longitude
        self.hashtagList = hashTagList
        self.viewCount = viewCount
        self.reactionTypeCounts = reactionTypeCounts
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
