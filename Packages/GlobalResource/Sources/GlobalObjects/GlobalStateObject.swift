//
//  FilGlobalStateObjecte.swift
//
//
//  Created by 최준영 on 2024/01/12.
//

import SwiftUI

public enum LocalDataError: Error {
    
    case dataNotFoundInLocal(name: String)
    
}

public class GlobalStateObject: ObservableObject {
    
    public static let shared = GlobalStateObject()
    
    public init() { }
    
    // UserDefaults key
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
}

// MARK: - 토큰
public extension GlobalStateObject {
    
    func saveTokenToLocal(accessToken: String, refreshToken: String) {
        
        UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
        UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)
        
    }
}
