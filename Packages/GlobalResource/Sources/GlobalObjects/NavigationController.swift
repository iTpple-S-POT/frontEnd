//
//  NavigationController.swift
//  
//
//  Created by 최준영 on 2024/01/02.
//

import SwiftUI

open class NavigationController<Destination>: ObservableObject {
    
    public typealias DestinationType = Destination
    
    @Published public var navigationStack: [Destination] = []
    
    public init() { }

    public func presentScreen(destination: Destination) {
        
        objectWillChange.send()
        
        navigationStack = [destination]
    }
    
    public func addToStack(destination: Destination) {
        
        objectWillChange.send()
        
        navigationStack.append(destination)
    }
    
    public func popTopView() {
    
        objectWillChange.send()
    
        let _ = navigationStack.popLast()
    }
    
    public func clearStack() {
        
        objectWillChange.send()
        
        navigationStack = []
    }
}
