//
//  PotModel.swift
//
//
//  Created by 최준영 on 2/14/24.
//

import SwiftUI

public class PotModel: ObservableObject {
    
    public let id: Int64
    public let userId: Int64
    public let categoryId: Int64
    public let content: String
    public let imageKey: String?
    public let expirationDate: String
    public let latitude: Double
    public let longitude: Double
    
    @Published public var hashTagList: [HashTagDTO]
    @Published public var viewCount: Int
    @Published public var reactionTypeCounts: [ReactionCountDTO]
    
    public init(
        id: Int64,
        userId: Int64,
        categoryId: Int64,
        content: String,
        imageKey: String?,
        expirationDate: String,
        latitude: Double,
        longitude: Double,
        hashTagList: [HashTagDTO],
        viewCount: Int,
        reactionTypeCounts: [ReactionCountDTO]) {
        self.id = id
        self.userId = userId
        self.categoryId = categoryId
        self.content = content
        self.imageKey = imageKey
        self.expirationDate = expirationDate
        self.latitude = latitude
        self.longitude = longitude
        self.hashTagList = hashTagList
        self.viewCount = viewCount
        self.reactionTypeCounts = reactionTypeCounts
    }
    
}

public class PotViewModel: Hashable {
    
    public static func == (lhs: PotViewModel, rhs: PotViewModel) -> Bool {
        lhs.model.id == rhs.model.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.model.id)
    }
    
    public var model: PotModel
    
    public init(model: PotModel) {
        self.model = model
    }
}


public extension PotModel {
    
    static func makePotModelFrom(potObject: PotObject) -> PotModel {
        
        return PotModel(
            id: potObject.id,
            userId: potObject.userId,
            categoryId: potObject.categoryId,
            content: potObject.content,
            imageKey: potObject.imageKey,
            expirationDate: potObject.expirationDate,
            latitude: potObject.latitude,
            longitude: potObject.longitude,
            hashTagList: potObject.hashtagList,
            viewCount: potObject.viewCount,
            reactionTypeCounts: potObject.reactionTypeCounts
        )
    }
}

extension PotModel: Hashable, Equatable {
    
    public static func == (lhs: PotModel, rhs: PotModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

public extension PotModel {
    
    func sendReaction(reactionType: String) async throws {
        
        do {
            
            let _ = try await APIRequestGlobalObject.shared.sendReaction(potId: self.id, reactionString: reactionType)
            
        } catch {
            
            throw error
        }
    }
}
