//
//  AssetCollectionType.swift
//
//
//  Created by 최준영 on 2024/01/07.
//

import Foundation

enum AssetCollectionType: Hashable {
    
    case resentAllPhotos
    case likedPhotos
    case albumPhotos
    
}

public struct CollectionTypeObject: Hashable {
    
    let type: AssetCollectionType
    
    public let title: String
    
    let indexForCollection: Int?
    
    init(type: AssetCollectionType, title: String, indexForCollection: Int? = nil) {
        self.type = type
        self.title = title
        self.indexForCollection = indexForCollection
    }
    
    public static let allPhoto = CollectionTypeObject(type: .resentAllPhotos, title: "최근 항목")
    
    public static let likedPhtoto = CollectionTypeObject(type: .likedPhotos, title: "즐겨찾는 항목")
    
}


