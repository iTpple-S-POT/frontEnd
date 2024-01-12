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
    
    @StateObject private var mainNavigation = MainNavigation()
    
    @StateObject private var screenModel = ContentScreenModel()
    
    
    public init() { }
    
    public var body: some View {
        NavigationStack(path: $mainNavigation.navigationStack) {
            
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
            
            // 토큰
            initialTokenTask()
            
        }
        .environmentObject(mainNavigation)
    }
}

extension ContentScreen {
    
    
    func initialTokenTask() {
        
        Task {
            
            do {
                
                // 테스트를 위한 토큰 삭제
                // APIRequestGlobalObject.shared.deleteTokenInLocal()
                
                try APIRequestGlobalObject.shared.checkTokenExistsInUserDefaults()
                    
                // 토큰 리프래쉬
                try await screenModel.refreshSpotToken()
                
                // 리프래쉬 성공후 이동
                try await Task.sleep(for: .seconds(1))
                
                DispatchQueue.main.async {
                    
                    mainNavigation.addToStack(destination: .mainScreen)
                    
                }
                
            }
            catch {
                
                if let netError = error as? SpotNetworkError {
                    
                    print("토큰 리프래쉬 실패 \(netError)")
                    
                }
                else if let tokenError = error as? SpotTokenError {
                    
                    print("로컬에 저장된 토큰이 없음, \(tokenError)")
                    
                } else {
                    
                    return
                }
                
                try await Task.sleep(for: .seconds(1))
                
                DispatchQueue.main.async {
                    
                    mainNavigation.addToStack(destination: .loginScreen)
                    
                }
                
            }
            
        }
        
    }
    
}

#Preview {
    ContentScreen()
}
