//
//  Token.swift
//  
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI
import Alamofire

public enum SpotTokenError: Error {
    
    case tokenDoentExistInLocal
    
}


// MARK: - 로컬에 저장된 토큰 체크
extension APIRequestGlobalObject {
    
    // 토큰 저장
    public func setToken(accessToken: String, refreshToken: String, isSaveInUserDefaults: Bool = false) {
        
        self.spotAccessToken = accessToken
        self.spotRefreshToken = refreshToken
        
        if isSaveInUserDefaults {
            
            UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
            UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)
            
        }
        
    }
    
    // 토큰 삭제
    public func deleteTokenInLocal() {
        
        UserDefaults.standard.removeObject(forKey: self.kAccessTokenKey)
        UserDefaults.standard.removeObject(forKey: self.kRefreshTokenKey)
        
        self.spotAccessToken = nil
        self.spotRefreshToken = nil
    
    }
    
    // 로컬 토큰 존재확인
    public func checkTokenExistsInUserDefaults() throws {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            // 로컬에 저장된 토큰을 저장
            setToken(accessToken: accessToken, refreshToken: refreshToken)
            
            return
            
        }
        
        throw SpotTokenError.tokenDoentExistInLocal
        
    }
    
}

public extension APIRequestGlobalObject {
    
    enum SocialLogInType {
        
        case kakao, apple
        
    }
    
    func sendAccessTokenToServer(accessToken: String, refreshToken: String, type: SocialLogInType) async throws -> TokenObject {
        
        let logInApi: SpotAPI = type == .kakao ? .getSpotTokenFromKakao : .getSpotTokenFromApple
        
        let url = try logInApi.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: false)
        
        print(accessToken)
        print(refreshToken)
        
        request.httpBody = try jsonEncoder.encode(TokenModel(accessToken: accessToken, refreshToken: refreshToken))
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            let severToken = try jsonDecoder.decode(TokenModel.self, from: data)
            
            return TokenObject(accessToken: severToken.accessToken, refreshToken: severToken.refreshToken)
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
    }
    
    func refreshTokens() async throws -> TokenObject {
        
        let url = try SpotAPI.refreshSpotToken.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post)
        
        let jsonObject: [String: Any] = ["refreshToken": spotRefreshToken!]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            let newSeverToken = try jsonDecoder.decode(TokenModel.self, from: data)
            
            return TokenObject(accessToken: newSeverToken.accessToken, refreshToken: newSeverToken.refreshToken)
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
    }
}
