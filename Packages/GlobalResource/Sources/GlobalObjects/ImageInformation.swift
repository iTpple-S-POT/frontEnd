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
    
    public var name: String?
    
    public var ext: String?
    
//    public var orientation: CGImagePropertyOrientation
    
    public init(data: Data, name: String? = nil, ext: String? = nil) {
        self.data = data
        self.name = name
        self.ext = ext
    }
    
}
