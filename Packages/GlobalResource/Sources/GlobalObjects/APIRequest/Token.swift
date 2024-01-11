//
//  Token.swift
//  
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI
import Alamofire

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
    
    // 로컬 토큰 존재확인
    public func checkTokenExistsInUserDefaults() -> (String, String)? {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            return (accessToken, refreshToken)
            
        }
        
        return nil
        
    }
    
}

public extension APIRequestGlobalObject {
    
    func sendAccessTokenToServer(accessToken: String, refreshToken: String) async throws -> TokenObject {
        
        let url = try SpotAPI.getSpotToken.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: false)
        
        request.httpBody = try jsonEncoder.encode(TokenModel(accessToken: accessToken, refreshToken: refreshToken))
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            switch httpResponse.statusCode {
            case 200..<300:
                // status code 정상
                let severToken = try jsonDecoder.decode(TokenModel.self, from: data)
                
                return TokenObject(accessToken: severToken.accessToken, refreshToken: severToken.refreshToken)
            case 400..<500:
                throw SpotNetworkError.clientError
            case 500..<600:
                throw SpotNetworkError.serverError
            default:
                throw SpotNetworkError.unProcessedStatusCode
            }
            
        }
        
        throw SpotNetworkError.unownedError
        
    }
    
    func refreshTokens() async throws -> TokenObject{
        
        let url = try! SpotAPI.refreshSpotToken.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post)
        
        request.httpBody = try jsonEncoder.encode(RefreshTokenModel(refreshToken: spotRefreshToken!))
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            switch httpResponse.statusCode {
            case 200..<300:
                // status code 정상
                let newSeverToken = try jsonDecoder.decode(TokenModel.self, from: data)
                
                return TokenObject(accessToken: newSeverToken.accessToken, refreshToken: newSeverToken.refreshToken)
            case 400..<500:
                throw SpotNetworkError.clientError
            case 500..<600:
                throw SpotNetworkError.serverError
            default:
                throw SpotNetworkError.unProcessedStatusCode
            }
            
        }
        
        throw SpotNetworkError.unownedError
        
    }
    
}
