//
//  LocationFetcher.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import Foundation
import CoreLocation
import Combine

class CJLocationFetcher: NSObject {
    
    static let shared = CJLocationFetcher()
    
    private let defaultLocation = LocationModel(
        latitude: 37.5518911,
        longitude: 126.9917937
    )
    
    let manager = CLLocationManager()
    
    let locationPublisher = PassthroughSubject<LocationViewModel, Never>()
    
    private override init() {
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 2
    }
}


extension CJLocationFetcher: CLLocationManagerDelegate {
    
    public func requestAuthorization() {
        
        manager.requestWhenInUseAuthorization()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            
            manager.startUpdatingLocation()
        default:
            return
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinate = locations.first!.coordinate
        
        print("CJLocationFetcher: 유저위치가 업데이트되었습니다.")
        
        let model = LocationModel(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        locationPublisher.send(LocationViewModel(model: model))
    }
}

extension CJLocationFetcher: LocationFetcher {
    
    var isAuthorizationValid: Bool {
        
        [.authorizedAlways, .authorizedWhenInUse].contains(manager.authorizationStatus)
    }
    
    func reqeustCurrentUserLocation() throws {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            requestAuthorization()
        case .restricted, .denied:
            throw LocationFetcherError.needsAuthInSetting
        default:
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
            return
        }
    }
    
    func requestDefaultLocation() -> LocationViewModel {
        
        let vm = LocationViewModel(model: defaultLocation)
        
        return vm
    }
}
