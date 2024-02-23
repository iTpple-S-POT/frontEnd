//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/18.
//

import Foundation
import CoreLocation
import Combine

public enum UserLocationError: Error {
    
    case cantGetUserLocation
    
}

public class CJLocationManager: NSObject {
    public let manager = CLLocationManager()
    
    public var currentLocationPublisher = PassthroughSubject<CLLocationCoordinate2D, UserLocationError>()
    
    // 현재 유저 위치 저장
    public var currentUserLocation: CLLocationCoordinate2D?
    
    // Userdefults
    static let kLatestUserLocation = "userLocation"
    
    public static let shared = CJLocationManager()
    
    private override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // TODO: 업데이트 거리를 몇미터로 할 것인지 정하기
        manager.distanceFilter = 1
    }
    
    /// 권한 요구 프롬프트 실행
    public func requestAuthorization() {
        
        manager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension CJLocationManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        default:
            return
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinate = locations.first!.coordinate
        
        currentUserLocation = coordinate
        
        currentLocationPublisher.send(coordinate)
        
        print("로케이션이 없데이트 되었습니다.")
        
        // 새로운 위치 로컬에 저장
        Self.saveUserLocationToLocal(coordinate: coordinate)
    }
    
}

// MARK: - 현재위치 요청
public extension CJLocationManager {
    
    func requestCurrentLocation() {
        
        manager.startUpdatingLocation()
        
    }
    
    static func getUserLocationFromLocal() -> CLLocationCoordinate2D {
        
        // 기본 주소: 서울특별시
        let defaultLocation = CLLocationCoordinate2D(latitude: 37.5518911, longitude: 126.9917937)
        
        if let coordinateArray = UserDefaults.standard.object(forKey: Self.kLatestUserLocation) as? [Double] {
            
            return CLLocationCoordinate2D(latitude: coordinateArray[0], longitude: coordinateArray[1])
            
        }
        
        return defaultLocation
    }
    
    static func saveUserLocationToLocal(coordinate: CLLocationCoordinate2D) {
        
        let coordinateArray = [coordinate.latitude, coordinate.longitude]
        UserDefaults.standard.set(coordinateArray, forKey: kLatestUserLocation)
        
    }
    
}
