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

struct RefreshTokenModel: Codable {
    
    var refreshToken: String
    
}


public struct TokenObject {
    
    public var accessToken: String
    public var refreshToken: String
    
}
