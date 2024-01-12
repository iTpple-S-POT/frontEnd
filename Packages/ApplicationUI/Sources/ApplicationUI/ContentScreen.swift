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
                
                // 로컬에 저장된 토큰을 저장
                APIRequestGlobalObject.shared.setToken(accessToken: acToken, refreshToken: rfToken)
                
                // 토큰 리프래쉬
                refreshSpotToken()
                
            } else {
                
                print("로컬에 토큰이 존재하지 않음")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    screenModel.addToStack(destination: .loginScreen)
                    
                }
                
            }
            
        }
        .environmentObject(screenModel)
    }
}

extension ContentScreen {
    
    func refreshSpotToken() {
        
        Task {
            
            do {
                
                let newTokens = try await APIRequestGlobalObject.shared.refreshTokens()
                
                print("토큰 리프래쉬 성공")
                
                // 새로운 토큰을 로컬에 저장
                APIRequestGlobalObject.shared.setToken(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken, isSaveInUserDefaults: true)
                
                try await Task.sleep(for: .seconds(1))
                
                DispatchQueue.main.async {
                    
                    screenModel.addToStack(destination: .mainScreen)
                    
                }
                
            }
            catch {
                
                if let netError = error as? SpotNetworkError {
                    
                    print("토큰 리프래쉬 실패 \(netError)")
                    
                }
                
                try await Task.sleep(for: .seconds(1))
                
                DispatchQueue.main.async {
                    
                    screenModel.addToStack(destination: .loginScreen)
                    
                }
                
            }
            
        }
        
        
    }
    
}

#Preview {
    ContentScreen()
}
