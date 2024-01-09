//
//  File.swift
//  
//
//  Created by 최준영 on 2024/01/04.
//

import Foundation

public struct ImageInformation: Identifiable, Equatable {
    
    public var id: UUID { UUID() }
    
    public var data: Data
    
    public var ext: String
    
    public init(data: Data, ext: String) {
        self.data = data
        self.ext = ext
    }
    
}

struct PotUploadObject {
    
    // 위치
    // 카테고리
    
    var imageInfo: ImageInformation
    
}


