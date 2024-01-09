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
    
    @Published var isLastestCenterAndMapEqual: Bool = false
    @Published var isUserAndLatestCenterEqual: Bool = false
    
    // 마지막으로 전달한 맵의 중앙점
    var lastestCenter = CLLocationCoordinate2D()
    
    // 유저의 가장최근 위치
    private var userPosition: CLLocationCoordinate2D!
    
    let locationManager = CJLocationManager.shared
    
    var userLocationSubscriber: AnyCancellable?
    
    private var isFirstUpdate = true
    
    func registerLocationSubscriber() {
        
        self.userLocationSubscriber = locationManager.currentLocationPublisher.sink { _ in
        } receiveValue: { coordinate in
            
            self.userPosition = coordinate
            
            DispatchQueue.main.async {
                
                self.isUserAndLatestCenterEqual = false
                
                // 첫 요청시에만 자동 업데이트
                // 이후에는 버튼 눌렀을 때만 업데이트
                if self.isFirstUpdate {
                    
                    self.isFirstUpdate = false
                    
                    self.userPosition = coordinate
                    
                    self.moveMapToCurrentLocation()
                    
                    print("최초 3박자 일치")
                    
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
        
        print("3박자 일치")
        
        self.lastestCenter = userPosition
        
        self.isUserAndLatestCenterEqual = true
        
        // 맵의 init, updateUIView순서대로 호출
        self.isLastestCenterAndMapEqual = true
        
    }
}
