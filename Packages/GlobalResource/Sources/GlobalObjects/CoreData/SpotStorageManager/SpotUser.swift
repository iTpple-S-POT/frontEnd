//
//  SpotUser.swift
//
//
//  Created by 최준영 on 1/18/24.
//

import CoreData

public extension SpotStorageManager {
    
    func loadUserInfo() async throws {
        
        // 로컬에 저장된 카테고리가 있음, 저장된 것이 없는 경우 빈배열을 반환함
        let userInfo: [SpotUser] = try fetchObjectsFromMainStorage()
        if !userInfo.isEmpty {
            
            print("로컬에 저장된 유저가 있음")
            
            // 백그라운드에서 서버값과 비교후 다를 시 업데이트
            Task.detached {
                
                let userInfoFromServer = try await APIRequestGlobalObject.shared.getUserInfo()
                
                try self.updateUserInfo(newUserInfo: userInfoFromServer)
                
            }
            
        } else {
            
            print("로컬에 저장된 유저가 없음")
            
            let userInfoFromServer = try await APIRequestGlobalObject.shared.getUserInfo()
            
            // TODO: 다른 데이터 생길경우 배치처리
            try self.insertUserInfoToMainStorage(userInfo: userInfoFromServer)
        }
    }
    
    func insertUserInfoToMainStorage(userInfo: UserInfoObject) throws {
        
        let users = try context.fetch(SpotUser.fetchRequest())
        
        if users.isEmpty {
            let spotUser = SpotUser(context: context)
            
            spotUser.id = userInfo.id
            spotUser.birthDay = userInfo.birthDay
            spotUser.nickName = userInfo.nickname
            spotUser.profileImageUrl = userInfo.profileImageUrl
            spotUser.gender = userInfo.gender
            spotUser.mbti = userInfo.mbti
            spotUser.name = userInfo.name
            spotUser.interests = userInfo.interests.joined(separator: ",")
            spotUser.loginType = userInfo.loginType
            spotUser.role = userInfo.role
            spotUser.status = userInfo.status
        } else {
            
            let user = users.first!
            
            user.id = userInfo.id
            user.birthDay = userInfo.birthDay
            user.nickName = userInfo.nickname
            user.profileImageUrl = userInfo.profileImageUrl
            user.gender = userInfo.gender
            user.mbti = userInfo.mbti
            user.name = userInfo.name
            user.interests = userInfo.interests.joined(separator: ",")
            user.loginType = userInfo.loginType
            user.role = userInfo.role
            user.status = userInfo.status
        }
        try context.save()
    }
    
    
    
    /// 현재 유저를 삭제한다.
    func deleteCurrentUser() throws {
        
        guard let currentUser = try context.fetch(SpotUser.fetchRequest()).first else {
            
            throw SpotStorageError.userUnavailable
        }
        
        context.delete(currentUser)
        
        try context.save()
    }
    
    /// 로컬에 존재하는 경우에만 업데이트
    func updateUserInfo(newUserInfo: UserInfoObject) throws {
        
        try insertUserInfoToMainStorage(userInfo: newUserInfo)
    }
}
