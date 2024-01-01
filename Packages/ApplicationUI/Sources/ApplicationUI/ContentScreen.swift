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

public struct ContentScreen: View {
    
    @StateObject private var apiRequestManager = APIRequestGlobalObject()
    
    @StateObject private var screenModel = ContentScreenModel()
    
    public init() { }
    
    public var body: some View {
        NavigationStack(path: $screenModel.navigationStack) {
            
            // root
            SplashScreen()
            
                .navigationDestination(for: ContentScreenModel.DestinationType.self) { nav in
                    switch nav {
                    case .loginScreen:
                        LoginScreen()
                            .onOpenURL { url in
                                
                                KakaoLoginManager.shared.completeSocialLogin(url: url)
                                
                            }
                    case .mainScreen:
                        Text("MainScreen")
                    }
                }
            
        }
        .onAppear {
            
            let opTokens = screenModel.checkIsSignedInBefore()
            
            if let (acToken, rfToken) = opTokens {
                
                apiRequestManager.spotAccessToken = acToken
                apiRequestManager.spotRefreshToken = rfToken
                
                screenModel.addToStack(destination: .mainScreen)
                
            } else {
                
                screenModel.addToStack(destination: .loginScreen)
                
            }
            
        }
        .environmentObject(apiRequestManager)
    }
}

class ContentScreenModel: NavigationController<MainNavDestination> {
    
    override init() {
        
        
    }
    
}


// MARK: - 로그인 여부 판단
extension ContentScreenModel {
    
    // root -> Login session or Main Screen
    func checkIsSignedInBefore() -> (String, String)? {
        
        // TODO: 토큰저장을 UserDefaults에서 KeyChain으로 업그레이드
        
        // case: 로그인을 처음시도, 리프래쉬 토큰 삭제
        if let accessToken = UserDefaults.standard.string(forKey: "spotAccessToken"), let refreshToken = UserDefaults.standard.string(forKey: "spotRefreshToken") {
            
            return (accessToken, refreshToken)
        }
        
        return nil
    }
    
}



#Preview {
    ContentScreen()
}

enum MainNavDestination {
    
    case loginScreen
    case mainScreen
    
}

class NavigationController<Destination>: ObservableObject {
    
    typealias DestinationType = Destination
    
    @Published var navigationStack: [Destination] = []

    func presentScreen(destination: Destination) {
        navigationStack = [destination]
    }
    
    func addToStack(destination: Destination) {
        navigationStack.append(destination)
    }
    
    func popTopView() {
        let _ = navigationStack.popLast()
    }
    
    func clearStack() {
        navigationStack = []
    }
}
