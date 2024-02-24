//
//  File.swift
//  
//
//  Created by 최준영 on 2/7/24.
//

import SwiftUI
import Combine

class MainScreenConfig: ObservableObject {
    
    var isPotDetailViewIsPresented = false
    @Published private(set) var tabViewMode: TabViewMode = .idleMode
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func setMode(mode: TabViewMode) {
        tabViewMode = mode
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
