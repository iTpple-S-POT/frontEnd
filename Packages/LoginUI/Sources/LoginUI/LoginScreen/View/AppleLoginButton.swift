//
//  AppleLoginButton.swift
//
//
//  Created by 최준영 on 1/17/24.
//

import SwiftUI
import GlobalObjects
import AuthenticationServices
import Combine

struct AppleLoginButton: View {
    
    let pub = PassthroughSubject<TokenObject?, Never>()
    
    let sub: AnyCancellable?
    
    init(completion: @escaping (TokenObject?) -> Void) {
        self.sub = pub.sink(receiveValue: completion)
    }
    
    var body: some View {
        
        Button {
            
            AppleLoginManager.shared.showAppleLogin()
            
        } label: {
            
            Image.makeImageFromBundle(bundle: .module, name: "apple_login_button", ext: .png)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 140, minHeight: 30, maxHeight: 56)
            
        }
        .onAppear {
            
            AppleLoginManager.shared.completion = { pub.send($0) }
        }
    }
}

class AppleLoginManager: NSObject {
    
    static let shared = AppleLoginManager()
    
    var completion: ((TokenObject?) -> Void)?
    
    override init() { super.init() }
    
    func showAppleLogin() {
        
        // 디바이스 로그인된 애플아이디에 대한 요청
        let appIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        
        appIdRequest.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [appIdRequest])
        
        controller.delegate = self
        
        controller.performRequests()
        
    }
    
    func handleAppIdCredential(credential: ASAuthorizationAppleIDCredential) {
    
        Task {
            
            do {
                
                guard let tokenData = credential.identityToken, let token = String(data: tokenData, encoding: .utf8) else {
                    fatalError()
                }
                
                print("애플로그인 \n", token)
                
                print("-----------")
                
                let tokenObject = try await APIRequestGlobalObject.shared.sendAccessTokenToServer(accessToken: token, refreshToken: "", type: .apple)
                
                completion?(tokenObject)
                
            } catch {
                
                print(error.localizedDescription)
                completion?(nil)
            }
        
        }
        
    }
    
}


// MARK: - ASAuthorizationControllerDelegate
extension AppleLoginManager: ASAuthorizationControllerDelegate {
    
    /// 성공시 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            handleAppIdCredential(credential: credential)
            
            
            
        } else {
            
            print("다른 방법으로 로그인")
        }
        
    }
    
    
    /// 실패시 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        
        
    }
    
}



