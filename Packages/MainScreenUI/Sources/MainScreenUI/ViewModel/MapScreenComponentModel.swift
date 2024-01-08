//
//  MapScreenComponentModel.swift
//
//
//  Created by 최준영 on 2024/01/08.
//

import SwiftUI
import CoreLocation
import Combine
import CJMapkit

enum SpotLocationError: Error {
    
    case unAuthorized
    
}

class MapScreenComponentModel: ObservableObject {
    
    @Published var mapCenterCoordinate = CLLocationCoordinate2D()
    
    private var updatedUserLocation: CLLocationCoordinate2D!
    
    let locationManager = CJLocationManager()
    
    var userLocationSubscriber: AnyCancellable?
    
    private var isFirstUpdate = true
    
    init() {
        
        self.userLocationSubscriber = locationManager.currentLocationPublisher.sink { _ in
        } receiveValue: { coordinate in
            
            self.updatedUserLocation = coordinate
            
            DispatchQueue.main.async {
                
                // 첫 요청시에만 자동 업데이트
                // 이후에는 버튼 눌렀을 때만 업데이트
                if self.isFirstUpdate {
                    
                    self.isFirstUpdate = false
                    
                    self.mapCenterCoordinate = coordinate
                    
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
    
    public func moveMapToCurrentLocation() {
        
        self.mapCenterCoordinate = updatedUserLocation
        
    }
}
