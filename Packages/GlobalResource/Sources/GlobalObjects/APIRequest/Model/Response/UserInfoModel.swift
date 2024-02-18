//
//  UserInfoModel.swift
//
//
//  Created by 최준영 on 1/18/24.
//

import Foundation


// MARK: - Response
struct UserInfoResponseModel: Decodable {
    
    let id: Int64
    let loginType: String?
    let role: String?
    let profileImageUrl: String?
    let name: String?
    let nickname: String?
    let phoneNumber: String?
    let birthDay: String?
    let gender: String?
    let mbti: String?
    let interests: [String]
    let status: String?
}

// MARK: - Reqeust
struct UserInfoRequestModel: Encodable {
    
    let nickname: String?
    let phoneNumber: String?
    let birthDay: String
    let gender: String?
    let mbti: String?
    let interests: [String]
}


// MARK: - Object
public struct UserInfoObject {
    
    public let id: Int64
    public let loginType: String?
    public let role: String?
    public let profileImageUrl: String?
    public let name: String?
    public let nickname: String?
    public let phoneNumber: String?
    public let birthDay: String?
    public let gender: String?
    public let mbti: String?
    public let interests: [String]
    public let status: String?
    
    public init(id: Int64, loginType: String?, role: String?, profileImageUrl: String?, name: String?, nickname: String?, phoneNumber: String?, birthDay: String?, gender: String?, mbti: String?, interests: [String], status: String?) {
        self.id = id
        self.loginType = loginType
        self.role = role
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.birthDay = birthDay
        self.gender = gender
        self.mbti = mbti
        self.interests = interests
        self.status = status
    }
    
}
