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
    
    private(set) var selectedPotModel: PotModel?
    @Published var presentPotDetailView = false
    
    init() {
        NotificationCenter.potSelection.addObserver(self, selector: #selector(singlePotSelected(_:)), name: .singlePotSelection, object: nil)
    }
    
    @objc
    func singlePotSelected(_ notification: Notification) {
        
        objectWillChange.send()
        
        let model = notification.object as! PotModel
        
        self.selectedPotModel = model
        
        self.presentPotDetailView = true
    }
}
