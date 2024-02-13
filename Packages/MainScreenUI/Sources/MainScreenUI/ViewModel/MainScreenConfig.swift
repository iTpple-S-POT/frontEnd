//
//  File.swift
//  
//
//  Created by 최준영 on 2/7/24.
//

import SwiftUI

class MainScreenConfig: ObservableObject {
    
    @Published var isPotDetailViewIsPresented = false
    @Published private(set) var tabViewMode: TabViewMode = .idleMode
    
    @MainActor
    func setMode(mode: TabViewMode) {
        tabViewMode = mode
    }
    
    @MainActor
    func onTabTransition(nextState: SpotTapItemSample, prevState: SpotTapItemSample) {
        
        if nextState == prevState { return }
        
        if nextState == .home, isPotDetailViewIsPresented { setMode(mode: .blackMode) }
        else { setMode(mode: .idleMode) }
    }
}

private struct MainScreenConfigKey: EnvironmentKey {
    static let defaultValue: MainScreenConfig = .init()
}


extension EnvironmentValues {
    var mainScreenConfig: MainScreenConfig {
        get { self[MainScreenConfigKey.self] }
        set { self[MainScreenConfigKey.self] = newValue }
    }
}
