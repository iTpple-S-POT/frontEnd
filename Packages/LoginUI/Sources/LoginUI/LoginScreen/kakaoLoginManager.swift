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
import Alamofire

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
                    
                    if let accessToken = oauthToken?.accessToken, let refreshToken = oauthToken?.refreshToken {
                                       // Send accessToken to the server
                        self.sendAccessTokenToServer(accessToken: accessToken, refreshToken: refreshToken) { success in
                            completion(true)
                        }
                    } else {
                        completion(false)
                    }
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
                        
                        if let accessToken = oauthToken?.accessToken, let refreshToken = oauthToken?.refreshToken {
                                           // Send accessToken to the server
                            self.sendAccessTokenToServer(accessToken: accessToken, refreshToken: refreshToken) { success in
                                completion(true)
                            }
                        } else {
                            completion(false)
                        }
                    }
                }
        }
    }
    
    private func sendAccessTokenToServer(accessToken: String, refreshToken: String, completion: @escaping (Bool) -> Void){
        let url = "http://43.201.220.214/auth/login/KAKAO"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                switch response.result {
                case .success(let data):
                    
                    if let responseDataString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseDataString)")
                    }
                    
                    completion(true)
                case .failure(let error):
                    print("Server error: \(error.localizedDescription)")
                    completion(false)
                }
        }
    }
}
