//
//  File.swift
//  
//
//  Created by 최준영 on 2024/01/12.
//

import SwiftUI
import GlobalObjects

class ContentScreenModel: ObservableObject {
    
    func refreshSpotToken() async throws {
        
        let newTokens = try await APIRequestGlobalObject.shared.refreshTokens()
        
        print("토큰 리프래쉬 성공")
        
        // 새로운 토큰을 로컬에 저장
        APIRequestGlobalObject.shared.setToken(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken, isSaveInUserDefaults: true)
        
    }
    
}
