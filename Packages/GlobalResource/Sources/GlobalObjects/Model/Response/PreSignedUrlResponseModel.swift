//
//  File.swift
//  
//
//  Created by 최준영 on 2024/01/06.
//

import Foundation


struct PreSignedUrlResponseModel: Decodable {
    
    var preSignedUrl: String
    var fileKey: String
    
}

public struct PreSignedUrlObject {
    
    public var preSignedUrl: String
    public var fileKey: String
}
