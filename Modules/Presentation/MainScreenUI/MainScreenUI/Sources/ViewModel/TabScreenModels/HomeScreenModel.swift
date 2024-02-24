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
    private(set) var userInfo: UserInfoObject?
    private(set) var selectedClusterModels: [PotModel]?
    @Published var presentPotDetailView = false
    @Published var presentPotsListView = false
    
    init() {
        NotificationCenter.potSelection.addObserver(self, selector: #selector(singlePotSelected(_:)), name: .singlePotSelection, object: nil)
        
        NotificationCenter.potSelection.addObserver(self, selector: #selector(potFromPotListView(_:)), name: .potFromPotListView, object: nil)
        
        NotificationCenter.potSelection.addObserver(self, selector: #selector(multiplePotsSelected(_:)), name: .multiplePotsSelection, object: nil)
    }
    
    @objc
    func singlePotSelected(_ notification: Notification) {
        
        objectWillChange.send()
        
        let model = notification.object as! PotModel
        
        self.selectedPotModel = model
        
        self.presentPotDetailView = true
    }
    
    @objc
    func potFromPotListView(_ notification: Notification) {
        
        objectWillChange.send()
        
        if let to = notification.object as? [String: Any] {
            
            self.selectedPotModel = to["model"] as? PotModel
            self.userInfo = to["userInfo"] as? UserInfoObject
            
            self.presentPotDetailView = true
        }
    }
    
    @objc
    func multiplePotsSelected(_ notification: Notification) {
        
        objectWillChange.send()
        
        let models = notification.object as! [PotModel]
        
        self.selectedClusterModels = models
        
        self.presentPotsListView = true
    }
}
