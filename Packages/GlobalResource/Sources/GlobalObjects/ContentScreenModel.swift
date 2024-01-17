//
//  File.swift
//  
//
//  Created by 최준영 on 1/18/24.
//

import Foundation

public class ContentScreenModel: ObservableObject {

    @Published public var showAlert = false
    public var alertTitle = ""
    public var alertMessage = ""
    
    // for UserDefaults
    // tokens
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
    public init() { }
    
}


// MARK: - 토큰
public extension ContentScreenModel {
    
    // 토큰 리프래쉬
    func refreshSpotToken() async throws {
        
        let newTokens = try await APIRequestGlobalObject.shared.refreshTokens()
        
        print("newToken(Access):", newTokens.accessToken, terminator: "\n")
        
        // 새로운 토큰을 로컬에 저장
        saveTokenToLocal(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
        
        // 새로운 토큰을 메모리에 저장
        APIRequestGlobalObject.shared.setSpotToken(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
    }
    
}

// MARK: - Alert
public extension ContentScreenModel {
    
    func showSeverError() {
        
        alertTitle = "네트워크 에러"
        alertMessage = "네트워크 연결을 확인해 주세요"
        showAlert = true   
    }
    
    func showDataError() {
        
        alertTitle = "기본 데이터 에러"
        alertMessage = "필수데이터를 불러올 수 없습니다."
        showAlert = true
    }
    
    func presentAlert(title: String, message: String) {
        
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
}

// MARK: - UserDefaults
public extension ContentScreenModel {
    
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

public enum InitialTaskError: Error {
    
    case networkFailure
    case refreshFailed
    case tokenCacheTaskFailed
    case dataTaskFailed
    
}

// MARK: - 초기 설정들
public extension ContentScreenModel {
    
    func initialTokenTask() async throws {
        
        do {
            
            // 테스트를 위한 토큰 삭제
            // APIRequestGlobalObject.shared.deleteTokenInLocal()
            
            try checkTokenExistsInUserDefaults()
                
            // 토큰 리프래쉬
            try await refreshSpotToken()
        }
        
        catch {
            
            if let tokenError = error as? LocalDataError {
                
                print("로컬에 저장된 토큰이 없음, \(tokenError)")
                
                throw InitialTaskError.tokenCacheTaskFailed
                
            }
            
            if let netError = error as? SpotNetworkError {
                
                print("네트워크 통신 실패 \(netError)")
                
                if case .notFoundError( _ ) = netError {
                    
                    throw InitialTaskError.refreshFailed
                }
            }
            
            throw InitialTaskError.networkFailure
            
        }
        
    }
    
    func initialDataTask() async throws {
        
        guard let _ = try? await SpotStorage.default.loadCategories() else {
            
            throw InitialTaskError.dataTaskFailed
        }
    }
}
