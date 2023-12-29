//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/18.
//

import Foundation
import CoreLocation

public class CJLocationManager: NSObject, CLLocationManagerDelegate {
    public let manager = CLLocationManager()
    
    public static let shared = CJLocationManager()
    
    private var updateMapViewCenter: ((CLLocation) -> ())?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    public func registerUpdatingCenterClosure(closure: @escaping (CLLocation) -> ()) {
        updateMapViewCenter = closure
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return
        case .authorizedWhenInUse:
            manager.requestLocation()
            return
        case .restricted, .denied:
            return
        default:
            return
        }
    }
    
    /// location property로 부터 retrieve실패
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    /// location이 업데이트 되면 해당 맵의 center를 업데이트
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.last {
            updateMapViewCenter?(currentLoc)
        }
    }
    
    /// 권한 요구 프롬프트 실행
    public func requestAuthorization() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}
