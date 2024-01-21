//
//  File.swift
//
//
//  Created by 최준영 on 2023/11/18.
//

import SwiftUI
import DefaultExtensions
import KakaoSDKAuth
import GlobalFonts
import GlobalObjects
import UserInformationUI
import Alamofire
import AuthenticationServices

public struct LoginScreen: View {
    
    @EnvironmentObject private var mainNavigation: MainNavigation
    @EnvironmentObject private var contentScreenModel: ContentScreenModel
    
    @ObservedObject private var screenModel = LoginScreenModel()
    
    public init() { }
    
    public var body: some View {
        
        VStack(spacing: 16) {
            
            // 메인 텍스트
            HStack {
                VStack(alignment: .leading) {
                    Text("동네,")
                    (
                        Text("일상을 ")
                        +
                        Text("공유하다")
                            .fontWeight(.semibold)
                    )
                }
                Spacer()
            }
            .font(.system(size: 40))
            .padding(.top, 64)
            
            // 스플래쉬 이미지
            // TODO: 완성된 이미지 삽입
            Image.makeImageFromBundle(bundle: .module, name: "login_illust", ext: .png)
                .resizable()
                .scaledToFit()
                .layoutPriority(1)
            
            // 로그인 버튼들
            VStack(spacing: 16) {
                
                AppleLoginButton(completion: handleLoginTask)
                
                KakaoLoginButton(completion: handleLoginTask)
                
            }
            .padding(.bottom, 27)
            
        }
        .padding(.horizontal, 21)
        
    }
    
}

extension LoginScreen {
    
    func handleLoginTask(tokens: TokenObject?) {
        
        guard let serverTokens = tokens else {
            
            contentScreenModel.presentAlert(title: "로그인 에러", message: "잠시후 다시 시도해 주세요.")
            return
        }
        
        print(serverTokens)
        
        APIRequestGlobalObject.shared.setSpotToken(accessToken: serverTokens.accessToken, refreshToken: serverTokens.refreshToken)
        
        UserDefaultsManager.saveTokenToLocal(accessToken: serverTokens.accessToken, refreshToken: serverTokens.refreshToken)
        
        Task {
            do {
                try await contentScreenModel.initialDataTask()
                
                print("--데이터 확보 성공--")
                
                let isInitial = try await contentScreenModel.checkIsUserInitialSignUp()
                
                if isInitial {
                    
                    mainNavigation.delayedNavigation(work: .add, destination: .welcomeScreen)
                    
                    return
                }
                
                mainNavigation.delayedNavigation(work: .add, destination: .mainScreen)
                
            } catch {
                
                guard let initialError = error as? InitialTaskError else {
                    
                    fatalError()
                }
                
                switch initialError {
                case .networkFailure:
                    
                    contentScreenModel.showSeverError()
                    
                case .dataTaskFailed:
                    
                    contentScreenModel.showDataError()
                default:
                    contentScreenModel.presentAlert(title: "에러", message: "알수 없는 에러")
                }
            }
        }
    }
}

#Preview {
    LoginScreen()
}
