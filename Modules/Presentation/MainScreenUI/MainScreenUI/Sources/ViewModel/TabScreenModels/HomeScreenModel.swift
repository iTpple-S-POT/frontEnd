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
    
    private(set) var selectedClusterModels: [PotModel]?
    @Published var presentPotsListView = false
    
    init() {
        NotificationCenter.potSelection.addObserver(self, selector: #selector(multiplePotsSelected(_:)), name: .multiplePotsSelection, object: nil)
    }
    
    @objc
    func multiplePotsSelected(_ notification: Notification) {
        
        objectWillChange.send()
        
        let models = notification.object as! [PotModel]
        
        self.selectedClusterModels = models
        
        self.presentPotsListView = true
    }
}
