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
                        Text("MainScreen")
                    case .preferenceScreen:
                        Text("PerferenceScreen")
                    }
                }
            
        }
        .onAppear {
            
            let opTokens = APIRequestGlobalObject.shared.checkTokenExistsInUserDefaults()
            
            if let (acToken, rfToken) = opTokens {
                
                APIRequestGlobalObject.shared.setToken(accessToken: acToken, refreshToken: rfToken)
                
                screenModel.addToStack(destination: .mainScreen)
                
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
