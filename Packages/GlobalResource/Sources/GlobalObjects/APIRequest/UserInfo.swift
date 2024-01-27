//
//  UserInfo.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI

public extension APIRequestGlobalObject {
    
    // 유저 정보 수신
    func getUserInfo() async throws -> UserInfoObject {
        
        let url = try SpotAPI.userInfo.getApiUrl()
        
        let request = try getURLRequest(url: url, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            let decoded = try jsonDecoder.decode(UserInfoResponseModel.self, from: data)
            
            return UserInfoObject(id: decoded.id, loginType: decoded.loginType, role: decoded.role, profileImageUrl: decoded.profileImageUrl, name: decoded.name, nickname: decoded.nickname, phoneNumber: decoded.phoneNumber, birthDay: decoded.birthDay, gender: decoded.gender, mbti: decoded.mbti, interests: decoded.interests, status: decoded.status)
            
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
    
    
    // 최초 유저 정보전송
    func sendInitialUserInfomation(object: UserInfoObject) async throws {
        
        let modelObject = UserInfoRequestModel(nickname: object.nickname, phoneNumber: object.phoneNumber, birthDay: object.birthDay!, gender: object.gender, mbti: object.mbti, interests: object.interests)
        
        let url = try SpotAPI.userInfo.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: true)
        
        request.httpBody = try jsonEncoder.encode(modelObject)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            return
            
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
        
    }
    
}


// MARK: - User Information
public extension APIRequestGlobalObject {
    
    func checkIsNickNameAvailable(nickName: String) async throws -> (isSuccess: Bool, reason: String) {
        
        let functionName = #function
        
        let url = try SpotAPI.userNickNameCheck.getApiUrl()
        
        let queries: [String: String] = [
            "nickname" : nickName,
        ]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = queries.map({ URLQueryItem(name: $0, value: $1) })
        
        let urlWithQuery = components.url!
        
        let request = try getURLRequest(url: urlWithQuery, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            switch httpResponse.statusCode {
            case (200..<300):
                return (true, "")
            case 401:
                throw SpotNetworkError.authorizationError(function: functionName)
            case 404:
                throw SpotNetworkError.notFoundError(description: functionName)
            case 400..<500:
                throw SpotNetworkError.clientError(function: functionName)
            case 500..<600:
                guard let error = try? jsonDecoder.decode(SpotErrorMessageModel.self, from: data) else {
                    
                    throw SpotNetworkError.serverError(function: functionName)
                }
                return (false, error.message)
            default:
                throw SpotNetworkError.unProcessedStatusCode(function: functionName)
            }
        } else {
            
            throw SpotNetworkError.unknownError(function: functionName)
        }
    }
}
