//
//  ContentScreen.swift
//
//
//  Created by 최준영 on 2024/01/01.
//

import SwiftUI 
import SplashUI

struct ContentScreen: View {
    
    @StateObject private var screenModel = ContentScreenModel()
    
    var body: some View {
        NavigationStack(path: $screenModel.navigationStack) {
            
            SplashScreen()
            
                .navigationDestination(for: ContentScreenModel.DestinationType.self) { nav in
                    switch nav {
                    case .loginScreen:
                        Text("loginScreen")
                    case .mainScreen:
                        Text("MainScreen")
                    }
                }
            
        }
    }
}

class ContentScreenModel: NavigationController<MainNavDestination> {
    
    override init() {
        
        
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
