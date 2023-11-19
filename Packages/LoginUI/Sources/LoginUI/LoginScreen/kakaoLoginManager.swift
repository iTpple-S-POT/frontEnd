//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/19.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon

class KakaoLoginManager {
    
    static let shared = KakaoLoginManager()
    
    private init() {
        //TODO: API_KEY 보관파일 만들기
        KakaoSDK.initSDK(appKey: "")
    }
    
    func executeLogin() {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    print(oauthToken!)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        print(oauthToken!)
                    }
                }
        }
    }
}
