//
//  MapScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import CJMapkit
import CoreLocation

struct MapScreenComponent: View {
    
    var annotationDummies: [PotAnnotation] {
        
        let longRange = 126.9244669...126.9254901
        let latRange = 37.550756...37.557527
        
        return PotAnnotationType.allCases.map {
            
            let long = Double.random(in: longRange)
            let lat = Double.random(in: latRange)
            
            return PotAnnotation(type: $0, coordinate: CLLocationCoordinate2DMake(lat, long))
            
        }
        
    }
    
    var body: some View {
        CJMapkitView(userLocation: CLLocation(latitude: 37.550756, longitude: 126.9254901), annotations: annotationDummies)
    }
}

#Preview {
    MapScreenComponent()
}
