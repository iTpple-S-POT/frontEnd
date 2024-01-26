//
//  Token.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import Foundation

struct TokenModel: Codable {
    
    var accessToken: String
    var refreshToken: String
    
}

public struct TokenObject {
    
    public var accessToken: String
    public var refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
}
