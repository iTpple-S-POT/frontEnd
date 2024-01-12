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
import GlobalObjects

public class KakaoLoginManager {
    
    typealias TokenResponseCompletion = (OAuthToken?, Error?) -> Void
    
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
    
    internal func executeLogin(completion: @escaping (Result<TokenObject, SpotNetworkError>) -> Void) {
        guard isInitialized else {
            fatalError("please initialize KakaoSDK first")
        }
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            UserApi.shared.loginWithKakaoTalk {
                
                self.tokenLogicCompletion(oauthToken: $0, error: $1, completion: completion)
                
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {
                
                self.tokenLogicCompletion(oauthToken: $0, error: $1, completion: completion)
                
            }
        }
    }
}


// MARK: - 공용 completion
extension KakaoLoginManager {
    
    func tokenLogicCompletion(oauthToken: OAuthToken?, error: Error?, completion: @escaping (Result<TokenObject, SpotNetworkError>) -> ()) {
        
        let functionName = #function
        
        if let error = error {
            
            completion(.failure(.kakaoServerError(function: functionName)))
            
        }
        else {
            
            if let accessToken = oauthToken?.accessToken, let refreshToken = oauthToken?.refreshToken {
                
                // 토큰을 서버로 전송
                Task {
                    
                    do {
                        
                        let token = try await APIRequestGlobalObject.shared.sendAccessTokenToServer(accessToken: accessToken, refreshToken: refreshToken, type: .kakao)
                        
                        completion(.success(token))
                        
                    }
                    catch {
                        
                        if let netError = error as? SpotNetworkError {
                            
                            return completion(.failure(netError))
                            
                        }
                        
                        completion(.failure(.unownedError(function: functionName)))
                        
                    }
                }
                
            } else {
                
                completion(.failure(.kakaoServerError(function: functionName)))
                
            }
        }
    }
}
