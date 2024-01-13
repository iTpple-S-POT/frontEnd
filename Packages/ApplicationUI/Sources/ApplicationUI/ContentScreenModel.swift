//
//  ContentScreenModel.swift
//
//
//  Created by 최준영 on 2024/01/12.
//

import SwiftUI
import GlobalObjects

class ContentScreenModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    
    
    // for UserDefaults
    // tokens
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
}


// MARK: - 토큰
extension ContentScreenModel {
    
    // 토큰 리프래쉬
    func refreshSpotToken() async throws {
        
        let newTokens = try await APIRequestGlobalObject.shared.refreshTokens()
        
        // 새로운 토큰을 로컬에 저장
        saveTokenToLocal(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
        
        // 새로운 토큰을 메모리에 저장
        APIRequestGlobalObject.shared.setSpotToken(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
    }
    
}

// MARK: - Alert
extension ContentScreenModel {
    
    func showSeverError() {
        
        self.alertTitle = "네트워크 에러"
        self.alertMessage = "네트워크 연결을 확인해 주세요"
        self.showAlert = true
        
    }
    
    func showDataError() {
        
        self.alertTitle = "기본 데이터 에러"
        self.alertMessage = "필수데이터를 불러올 수 없습니다."
        self.showAlert = true
        
    }
    
}

// MARK: - UserDefaults
extension ContentScreenModel {
    
    // 로컬에 토큰 저장
    func saveTokenToLocal(accessToken: String, refreshToken: String) {
        
        UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
        UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)
        
    }
    
    // 로컬에 저장된 토큰 삭제
    func deleteTokenInLocal() {
        
        UserDefaults.standard.removeObject(forKey: self.kAccessTokenKey)
        UserDefaults.standard.removeObject(forKey: self.kRefreshTokenKey)
    
    }
    
    // 로컬 토큰 존재확인
    func checkTokenExistsInUserDefaults() throws {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            // 로컬에 저장된 토큰을 메모리에 저장
            APIRequestGlobalObject.shared.setSpotToken(accessToken: accessToken, refreshToken: refreshToken)
            
            return
            
        }
        
        throw LocalDataError.dataNotFoundInLocal(name: "Token")
    }
    
}

