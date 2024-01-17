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
    
    @StateObject private var globalStateObject = GlobalStateObject()
    
    
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
                    case .dataLoadingScreen:
                        // TODO: 수정 예정
                        Text("데이터 로딩 스크린")
                            .task {
                                
                                do {
                                    
                                    try await SpotStorage.default.loadCategories()
                                    
                                    mainNavigation.delayedNavigation(work: .add, destination: .mainScreen)
                                    
                                } catch {
                                    
                                    print("데이터 로딩 에러")
                                    
                                }
                                
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
        .task {
            
            do {
                
                // 토큰
                try await initialTokenTask()
                
                print("--토큰 성공--")
                
                mainNavigation.delayedNavigation(work: .add, destination: .dataLoadingScreen)
                
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
        .alert(isPresented: $screenModel.showAlert, content: {
            Alert(title: Text(screenModel.alertTitle), message: Text(screenModel.alertMessage), dismissButton: .default(Text("닫기")))
        })
        .environmentObject(mainNavigation)
        .environmentObject(globalStateObject)
        .environment(\.managedObjectContext, SpotStorage.default.mainStorageManager.context)
    }
}

enum InitialTaskError: Error {
    
    case networkFailure
    case refreshFailed
    case tokenCacheTaskFailed
    case dataTaskFailed
    
}

extension ContentScreen {
    
    func initialTokenTask() async throws {
        
        do {
            
            // 테스트를 위한 토큰 삭제
            // APIRequestGlobalObject.shared.deleteTokenInLocal()
            
            try screenModel.checkTokenExistsInUserDefaults()
                
            // 토큰 리프래쉬
            try await screenModel.refreshSpotToken()
        }
        
        catch {
            
            if let tokenError = error as? LocalDataError {
                
                print("로컬에 저장된 토큰이 없음, \(tokenError)")
                
                throw InitialTaskError.tokenCacheTaskFailed
                
            }
            
            if let netError = error as? SpotNetworkError {
                
                print("네트워크 통신 실패 \(netError)")
                
                if case .notFoundError( _ ) = netError {
                    
                    throw InitialTaskError.refreshFailed
                }
            }
            
            throw InitialTaskError.networkFailure
            
        }
        
    }
    
}

#Preview {
    ContentScreen()
}
