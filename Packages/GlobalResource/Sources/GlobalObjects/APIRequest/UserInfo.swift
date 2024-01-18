//
//  UserInfo.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI

public extension APIRequestGlobalObject {
    
    // 유저 정보 수신
    func getUserInfo() async throws -> UserInfObject {
        
        let url = try SpotAPI.userInfo.getApiUrl()
        
        let request = try getURLRequest(url: url, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            let decoded = try jsonDecoder.decode(UserInfoResponseModel.self, from: data)
            
            return UserInfObject(id: decoded.id, loginType: decoded.loginType, role: decoded.role, profileImageUrl: decoded.profileImageUrl, name: decoded.name, nickname: decoded.nickname, phoneNumber: decoded.phoneNumber, birthDay: decoded.birthDay, gender: decoded.gender, mbti: decoded.mbti, interests: decoded.interests, status: decoded.status)
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
    }
    
    
    // 최초 유저 정보전송
    func sendInitialUserInfomation(object: UserInfObject) async throws {
        
        let modelObject = UserInfoRequestModel(nickname: object.nickname, phoneNumber: object.phoneNumber, birthDay: object.birthDay!, gender: object.gender, mbti: object.mbti, interests: object.interests)
        
        let url = try SpotAPI.userInfo.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: true)
        
        request.httpBody = try jsonEncoder.encode(modelObject)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            return
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
        
    }
    
}
