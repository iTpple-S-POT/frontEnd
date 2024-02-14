//
//  HomeScreenModel.swift
//
//
//  Created by 최준영 on 2/14/24.
//

import SwiftUI
import GlobalObjects

@MainActor
class HomeScreenModel: ObservableObject {
    
    @Published private(set) var selectedPotObject: PotObject?
    @Published var presentPotDetailView = false
    
    init() {
        NotificationCenter.potSelection.addObserver(self, selector: #selector(singlePotSelected(_:)), name: .singlePotSelection, object: nil)
    }
    
    @objc
    func singlePotSelected(_ notification: Notification) {
        
        let object = notification.object as! PotObject
        
        self.selectedPotObject = object
        
        self.presentPotDetailView = true
    }
}
