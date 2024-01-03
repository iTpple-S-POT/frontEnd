//
//  GlobalObject.swift
//
//
//  Created by 최준영 on 2024/01/01.
//

import SwiftUI

public struct APIRequestGlobalObject {
    
    public var spotAccessToken: String!
    public var spotRefreshToken: String!
    
    public static var shared: APIRequestGlobalObject = .init()
    
    private init() { }
    
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
    public mutating func setToken(accessToken: String, refreshToken: String, isSaveInUserDefaults: Bool = false) {
        
        self.spotAccessToken = accessToken
        self.spotRefreshToken = refreshToken
        let refreshToken = UserDefaults.standard.string(forKey: "spotRefreshToken")
        
        if isSaveInUserDefaults {
            
            UserDefaults.standard.setValue(accessToken, forKey: self.kAccessTokenKey)
            UserDefaults.standard.setValue(refreshToken, forKey: self.kRefreshTokenKey)
            
        }
        
    }
    
    public func checkTokenExistsInUserDefaults() -> (String, String)? {
        
        if let accessToken = UserDefaults.standard.string(forKey: "spotAccessToken"), let refreshToken = UserDefaults.standard.string(forKey: "spotRefreshToken") {
            
            return (accessToken, refreshToken)
            
        }
        
        return nil
        
    }
    
}
