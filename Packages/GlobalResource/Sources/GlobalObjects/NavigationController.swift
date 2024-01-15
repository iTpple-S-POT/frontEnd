//
//  NavigationController.swift
//  
//
//  Created by 최준영 on 2024/01/02.
//

import SwiftUI

@MainActor
open class NavigationController<Destination>: ObservableObject {
    
    public typealias DestinationType = Destination
    
    @Published public var navigationStack: [DestinationType] = []
    
    public init() { }

    public func presentScreen(destination: DestinationType) {
        
        navigationStack = [destination]
    }
    
    public func addToStack(destination: DestinationType) {
        // 딜레이
        navigationStack.append(destination)
        
    }
    
    public func popTopView() {
    
        let _ = navigationStack.popLast()
    }
    
    public func clearStack() {
        
        navigationStack = []
    }
    
    public enum NavigationWork {
        case add, present, pop, clear
    }
    
    public func delayedNavigation(work: NavigationWork, destination: DestinationType?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            switch work {
            case .add:
                guard let des = destination else {
                    fatalError("destination 전달안됨")
                }
                self.addToStack(destination: des)
            case .present:
                guard let des = destination else {
                    fatalError("destination 전달안됨")
                }
                self.presentScreen(destination: des)
            case .pop:
                self.popTopView()
            case .clear:
                self.clearStack()
            }
            
        }
        
    }
}
