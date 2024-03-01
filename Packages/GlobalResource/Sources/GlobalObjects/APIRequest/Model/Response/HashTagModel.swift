//
//  File.swift
//  
//
//  Created by 최준영 on 2/15/24.
//

import Foundation

public struct HashTagDTO: Decodable, Hashable {
    
    public var hashtagId: Int64
    public var hashtag: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashtagId)
    }
}
