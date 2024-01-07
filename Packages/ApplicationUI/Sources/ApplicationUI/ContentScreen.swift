//
//  ContentScreen.swift
//
//
//  Created by 최준영 on 2024/01/01.
//

import SwiftUI 
import SplashUI
import LoginUI
import Alamofire
import GlobalObjects
import MainScreenUI

public struct ContentScreen: View {
    
    @StateObject private var screenModel = MainNavigation()
    
    public init() { }
    
    public var body: some View {
        NavigationStack(path: $screenModel.navigationStack) {
            
            // root
            VStack {
                
                SplashScreen()
                
            }
            
                .navigationDestination(for: MainNavigation.DestinationType.self) { nav in
                    switch nav {
                    case .loginScreen:
                        LoginScreen()
                            .onOpenURL { url in
                                
                                KakaoLoginManager.shared.completeSocialLogin(url: url)
                                
                            }
                            .navigationBarBackButtonHidden()
                    case .mainScreen:
                        MainScreen()
                            .navigationBarBackButtonHidden()
                    case .preferenceScreen:
                        Text("PerferenceScreen")
                    }
                }
            
        }
        .onAppear {
            
            let opTokens = APIRequestGlobalObject.shared.checkTokenExistsInUserDefaults()
            
            if let (acToken, rfToken) = opTokens {
                
                APIRequestGlobalObject.shared.setToken(accessToken: acToken, refreshToken: rfToken)
                
                // refresh
                APIRequestGlobalObject.shared.refreshTokens { result in
                    switch result {
                    case .success(let success):
                        print("리프래쉬 성공")
                        APIRequestGlobalObject.shared.setToken(accessToken: success.accessToken, refreshToken: success.refreshToken, isSaveInUserDefaults: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            
                            screenModel.addToStack(destination: .mainScreen)
                            
                        }
                    case .failure(let error):
                        
                        switch error {
                        case .cantFindRefreshToken:
                            print("리프래쉬 토큰을 찾을 수 없음")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                
                                screenModel.addToStack(destination: .loginScreen)
                                
                            }
                        default:
                            print("오류")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                
                                screenModel.addToStack(destination: .loginScreen)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    screenModel.addToStack(destination: .loginScreen)
                    
                }
                
            }
            
        }
        .environmentObject(screenModel)
    }
}

#Preview {
    ContentScreen()
}
