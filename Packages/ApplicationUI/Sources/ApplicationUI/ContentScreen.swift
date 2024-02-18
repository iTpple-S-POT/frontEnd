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
import UserInformationUI

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
                    case .welcomeScreen:
                        WelcomeScreen()
                            .navigationBarBackButtonHidden()
                    case .preferenceScreen:
                        UserInformationConfigurationScreen()
                            .navigationBarBackButtonHidden()
                    }
                }
            
        }
        .task {
            
            do {
                
                // 토큰
                try await screenModel.initialTokenTask()
                
                print("--토큰 성공--")
                
                try await screenModel.initialDataTask()
                
                print("--데이터 확보 성공--")
                
                // 유저프로필 업데이트
                
                let isInitial = try await screenModel.checkIsUserInitialSignUp()
                
                if isInitial {
                    
                    print("--유저 선호 미입력 유저--")
                    
                    mainNavigation.delayedNavigation(work: .add, destination: .preferenceScreen)
                    
                    return
                }
                
                print("--유저 선호를 입력한 유저--")
                
                mainNavigation.delayedNavigation(work: .add, destination: .mainScreen)
                
            } catch {
                
                guard let initialError = error as? InitialTaskError else {
                    
                    fatalError()
                }
                
                switch initialError {
                case .networkFailure:
                    
                    screenModel.showSeverError()
                    
                case .tokenCacheTaskFailed, .refreshFailed:
                    
                    mainNavigation.delayedNavigation(work: .add, destination: .loginScreen)
                    
                case .dataTaskFailed:
                    
                    screenModel.showDataError()
                }
                
            }
            
        }
        .modifier(AlertProvider(showAlert: $screenModel.showAlert, title: screenModel.alertTitle, message: screenModel.alertMessage))
        .environmentObject(mainNavigation)
        .environmentObject(screenModel)
        .environment(\.managedObjectContext, SpotStorage.default.mainStorageManager.context)
    }
}

#Preview {
    ContentScreen()
}
