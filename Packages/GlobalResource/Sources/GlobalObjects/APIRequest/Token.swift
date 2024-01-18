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

public extension APIRequestGlobalObject {
    
    enum SocialLogInType {
        
        case kakao, apple
        
    }
    
    func sendAccessTokenToServer(accessToken: String, refreshToken: String, type: LoginType) async throws -> TokenObject {
        
        let url = try SpotAPI.getSpotTokenFrom(service: type).getApiUrl()
        
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
    
    func setSpotToken(accessToken: String, refreshToken: String) {
        
        self.spotAccessToken = accessToken
        self.spotRefreshToken = refreshToken
    }
}
