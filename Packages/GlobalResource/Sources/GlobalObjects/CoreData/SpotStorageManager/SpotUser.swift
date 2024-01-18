//
//  SpotUser.swift
//
//
//  Created by 최준영 on 1/18/24.
//

import CoreData

extension SpotStorageManager {
    
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
            try self.insertUserInfoToMainStorage(userInfo: userInfoFromServer, immediateSave: true)
        }
    }
    
    func insertUserInfoToMainStorage(userInfo: UserInfObject, immediateSave: Bool = false) throws {
        
        let context = context
        
        let spotUser = SpotUser(context: context)
        
        // TODO: 필요한 유저데이터 추가확인
        spotUser.id = userInfo.id
        spotUser.nickName = userInfo.nickname
        spotUser.profileImageUrl = userInfo.profileImageUrl
        
        if immediateSave {
            try context.save()
            
        }
        
    }
    
    /// 로컬에 존재하는 경우에만 업데이트
    func updateUserInfo(newUserInfo: UserInfObject) throws {
        
        let oldUserInfo: [SpotUser] = try fetchObjectsFromMainStorage()
        
        // 저장된 것이 없는 경우, 업데이트할 것이 없음으로 내용을 그대로 저장소에 저장
        if oldUserInfo.isEmpty {
            
            try insertUserInfoToMainStorage(userInfo: newUserInfo, immediateSave: true)
            
            return
        }
        
        let oldUser = oldUserInfo.first!
        
        oldUser.id = newUserInfo.id
        oldUser.nickName = newUserInfo.nickname
        oldUser.profileImageUrl = newUserInfo.profileImageUrl
        
        // 변동사항이 있는 경우 업데이트, 백그라운드 실행
        if context.hasChanges {
            
            Task.detached {
                
                try? await self.container.performBackgroundTask { context in
                    
                    try context.save()
                    
                    print("메인 저장소 저장 성공")
                }
            }
        }
    }
}
