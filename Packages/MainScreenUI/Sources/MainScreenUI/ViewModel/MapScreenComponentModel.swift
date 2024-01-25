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
import GlobalObjects

enum SpotLocationError: Error {
    
    case unAuthorized
    
}

class MapScreenComponentModel: ObservableObject {
    
    @Published var isLastestCenterAndMapEqual: Bool = false
    @Published var isUserAndLatestCenterEqual: Bool = false
    
    @Published var annotations: [AnnotationClassType] = []
    
    // 마지막으로 전달한 맵의 중앙점
    var lastestCenter = CLLocationCoordinate2D()
    
    // 유저의 가장최근 위치
    private var userPosition: CLLocationCoordinate2D!
    
    // 현재 지도의 중심
    var currentCenterPositionOfMap: CLLocationCoordinate2D!
    
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
                    
                    // 현재 유저 위치
                    self.userPosition = coordinate
                    
                    self.moveMapToCurrentLocation()
                    
                    // 팟 조회
                    self.fetchPots(location: coordinate)
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
        
        print("실시간 위치, 지도 중심, 가장최근위치 일치")
        
        self.lastestCenter = userPosition
        
        self.currentCenterPositionOfMap = userPosition
        
        self.isUserAndLatestCenterEqual = true
        
        // 맵의 init, updateUIView순서대로 호출
        self.isLastestCenterAndMapEqual = true
        
    }
    
    func fetchPotsFromCurrentMapCenter() {
        
        fetchPots(location: currentCenterPositionOfMap)
        
    }
    
    func fetchPots(location: CLLocationCoordinate2D) {
        
        let functionName = #function
        
        Task {
            
            do {
                
                // 로컬데이터 업로드(자동 필터링)
                try await SpotStorage.default.filteringLocalPots()
                print("팟 필터링 성공", functionName)
                
                // 서버 요청한 데이터 메모리에 올림
                let potsFromServer = try await APIRequestGlobalObject.shared.getPots(latitude: location.latitude, longitude: location.longitude, diameter: 300)
                
                print("서버에서 팟 가져오기 성공 현위치 팟개수: \(potsFromServer.count)개", functionName)
                
                // id가 같은 경우 삽입이 발생히지 않음
                try await SpotStorage.default.insertPots(objects: potsFromServer)
                
                print("서버에서 가져온 팟을 삽입 성공", functionName)
                
            } catch {
                
                print("초기 팟 처리 실패", functionName)
                
                print(error.localizedDescription)
            }
            
        }
        
    }
}
