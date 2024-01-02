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

enum SpotNetworkError: Error {
    
    // TODO: 네트워크 에러 구체화
    case serverError
    case dataTransferError
    case wrongDataTransfer
    
}

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
    
    internal func executeLogin(completion: @escaping (Result<SpotTokenModel, SpotNetworkError>) -> Void) {
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
    
    private func sendAccessTokenToServer(accessToken: String, refreshToken: String, completion: @escaping (Result<SpotTokenModel, SpotNetworkError>) -> Void) {
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
                    
                    if let decoded = try? JSONDecoder().decode(SpotTokenModel.self, from: data) {
                        
                        completion(.success(decoded))
                        
                        return
                        
                    }
                    
                    // 잘못된 데이터 전송으로인한 디코딩 실패
                    completion(.failure(.wrongDataTransfer))
                    
                    
                case .failure(let error):
                    
                    print("Server error: \(error.localizedDescription)")
                    
                    completion(.failure(.serverError))
                    
                }
        }
    }
}


// MARK: - 공용 completion
extension KakaoLoginManager {
    
    func tokenLogicCompletion(oauthToken: OAuthToken?, error: Error?, completion: @escaping (Result<SpotTokenModel, SpotNetworkError>) -> ()) {
        
        if let error = error {
            
            // TODO: 추후 에러 구체화
            completion(.failure(.serverError))
            
        }
        else {
            
            if let accessToken = oauthToken?.accessToken, let refreshToken = oauthToken?.refreshToken {
                               // Send accessToken to the server
                self.sendAccessTokenToServer(accessToken: accessToken, refreshToken: refreshToken) { result in
                    
                    switch result {
                    case .success(let data):
                        
                        completion(.success(data))
                        
                    case .failure(let failure):
                        
                        // TODO: 추후 구체화
                        completion(.failure(.serverError))
                        
                    }
                    
                }
            } else {
                
                // TODO: 추후 구체화
                completion(.failure(.dataTransferError))
                
            }
        }
    }
}
