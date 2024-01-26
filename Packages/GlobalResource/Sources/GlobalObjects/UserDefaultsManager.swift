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

public class UserDefaultsManager: ObservableObject {
    
    private init() { }
    
    // UserDefaults key
    static let kAccessTokenKey = "spotAccessToken"
    static let kRefreshTokenKey = "spotRefreshToken"
    
}

// MARK: - 토큰
public extension UserDefaultsManager {
    
    // 로컬에 토큰 저장
    static func saveTokenToLocal(accessToken: String, refreshToken: String) {
        
        UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
        UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)
        
    }
    
    // 로컬에 저장된 토큰 삭제
    static func deleteTokenInLocal() {
        
        UserDefaults.standard.removeObject(forKey: self.kAccessTokenKey)
        UserDefaults.standard.removeObject(forKey: self.kRefreshTokenKey)
    
    }
    
    // 로컬 토큰 존재확인
    static func checkTokenExistsInUserDefaults() throws {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            // 로컬에 저장된 토큰을 메모리에 저장
            APIRequestGlobalObject.shared.setSpotToken(accessToken: accessToken, refreshToken: refreshToken)
            
            return
            
        }
        
        throw LocalDataError.dataNotFoundInLocal(name: "Token")
    }

}
