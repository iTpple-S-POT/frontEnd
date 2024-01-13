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
                
                // 데이터
                try await intialDataTask()
                
                print("--데이터 성공--")
                
                try? await Task.sleep(for: .seconds(1))
                
                Task { @MainActor in
                    
                    mainNavigation.addToStack(destination: .mainScreen)
                }
                
            } catch {
                
                guard let initialError = error as? InitialTaskError else {
                    
                    fatalError()
                }
                
                switch initialError {
                case .networkFailure:
                    
                    screenModel.showSeverError()
                    
                case .tokenCacheTaskFailed, .refreshFailed:
                    
                    try? await Task.sleep(for: .seconds(1))
                    
                    Task { @MainActor in
                        
                        mainNavigation.addToStack(destination: .loginScreen)
                    }
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
            
            if let tokenError = error as? SpotTokenError {
                
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
    
    func intialDataTask() async throws {
        
        do {
            
            var categories: [CategoryObject]!
            
            if let localData = try? screenModel.checkCategoriesExistsInUserDefaults() {
                
                print("카테고리를 로컬에서 가져옴")
                
                categories = localData
                
            } else {
                
                let serverData = try await APIRequestGlobalObject.shared.getCategoryFromServer()
                
                print("카테고리: 서버에서 가져오기 성공")
                
                categories = serverData
            }
            
            globalStateObject.setCategories(categories: categories)
            
        } catch {
            
            if let netError = error as? SpotNetworkError {
                
                throw InitialTaskError.networkFailure
                
            }
            
            throw InitialTaskError.dataTaskFailed
            
        }
    }
    
}

#Preview {
    ContentScreen()
}
