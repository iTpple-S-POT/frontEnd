//
//  LocationViewModel.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import Foundation
import MapKit

class LocationViewModel {
    
    static let `default` = LocationViewModel(model: LocationModel(
        latitude: 37.5518911,
        longitude: 126.9917937
    ))
    
    var model: LocationModel
    
    init(model: LocationModel) {
        self.model = model
    }
    
    func getCLCoordinate2D() -> CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
    }
}
