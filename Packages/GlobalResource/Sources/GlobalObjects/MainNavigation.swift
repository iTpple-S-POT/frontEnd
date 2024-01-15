//
//  MainNavigation.swift
//
//
//  Created by 최준영 on 2024/01/02.
//

import Foundation

public final class MainNavigation: NavigationController<MainNavDestination> {
    
    public override init() {
        
        
    }
    
}

@frozen
public enum MainNavDestination {
    
    case loginScreen
    case mainScreen
    case preferenceScreen
    case dataLoadingScreen
    
}
