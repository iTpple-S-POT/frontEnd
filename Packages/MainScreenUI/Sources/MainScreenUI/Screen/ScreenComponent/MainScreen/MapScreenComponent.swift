//
//  MapScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import CJMapkit
import MapKit
import CoreLocation

struct MapScreenComponent: View {
    
    @StateObject private var screenModel = MapScreenComponentModel()
    
    var body: some View {
        MapkitViewRepresentable(userLocation: $screenModel.userLocation, annotations: [])
            .onAppear {
                
                do {
                    try screenModel.checkLocationAuthorization()
                }
                catch {
                    
                }
                
            }
        
    }
}

enum SpotLocationError: Error {
    
    case unAuthorized
    
}

class MapScreenComponentModel: ObservableObject {
    
    @Published var userLocation = CLLocationCoordinate2D()
    
    let locationManager = CJLocationManager()
    
    init() {
        
        locationManager.currentLocationCompletion = { result in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    
                    self.userLocation = location.coordinate
                    
                }
            case .failure( _ ):
                // 1초후 위치요청을 다시보냅니다.
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.requestCurrentLocation()
                }
            }
        }
    }
    
    func checkLocationAuthorization() throws {
        
        let authorization = locationManager.manager.authorizationStatus
        
        switch authorization {
        case .notDetermined:
            locationManager.requestAuthorization()
        case .restricted, .denied:
            throw SpotLocationError.unAuthorized
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            requestCurrentLocation()
        @unknown default:
            print("새로운 위치 인증 권한이 추가되었음")
            locationManager.requestAuthorization()
        }
        
    }
    
    private func requestCurrentLocation() {
        
        locationManager.requestCurrentLocation()
    }
}

#Preview {
    MapScreenComponent()
}
