//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/19.
//

import Foundation
import DefaultExtensions
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth

public class KakaoLoginManager {
    
    public static let shared = KakaoLoginManager()
    
    private init() { }
    
    private var isInitialized = false
    
    public func initKakaoSDKWith(appKey: String) {
        KakaoSDK.initSDK(appKey: appKey)
        isInitialized = true
    }
    
    public func completeSocialLogin(url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            let _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    internal func executeLogin(completion: @escaping (Bool) -> Void) {
        guard isInitialized else {
            fatalError("please initialize KakaoSDK first")
        }
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    completion(false)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    print(oauthToken!)
                    
                    completion(true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        completion(false)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        print(oauthToken!)
                        
                        completion(true)
                    }
                }
        }
    }
}
