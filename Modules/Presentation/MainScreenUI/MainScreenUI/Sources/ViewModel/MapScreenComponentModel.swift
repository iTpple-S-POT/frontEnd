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

extension Notification.Name {
    static let potUpload: Self = .init("potUpload")
}

enum SpotLocationError: Error {
    
    case unAuthorized
    
}

enum SpotPotAnnotationError: Error {
    
    case removeFailure
}

@MainActor
class MapScreenComponentModel: ObservableObject {
    
    @Published var isLastestCenterAndMapEqual: Bool = false
    @Published var isUserAndLatestCenterEqual: Bool = false
    @Published var potObjects: Set<PotObject> = []
    @Published var showAlert = false
    @Published var userPositionIsAvailable = false
    
    var alertTitle = ""
    var alertMessage = ""
    
    // 마지막으로 전달한 맵의 중앙점
    var lastestCenter = CLLocationCoordinate2D()
    
    // 유저의 가장최근 위치
    private var userPosition: CLLocationCoordinate2D!
    
    // 현재 지도의 중심
    var currentCenterPositionOfMap: CLLocationCoordinate2D!
    
    let locationManager = CJLocationManager.shared
    
    var userLocationSubscriber: AnyCancellable?
    
    private var isFirstUpdate = true
    
    init() {
        
        NotificationCenter.potSelection.addObserver(self, selector: #selector(potUploadAction(_:)), name: .potUpload, object: nil)
    }
    
    @objc
    func potUploadAction(_ notification: Notification) {
        
        if let objects = notification.object as? [String: Any] {
            
            let categoryId = objects["categoryId"] as! Int64
            let content = objects["content"] as! String
            let hashtagList = objects["hashtagList"] as! [String]
            let imageInfo = objects["imageInfo"] as! ImageInformation
            
            self.uploadPot(
                categoryId: categoryId,
                content: content,
                hashtagList: hashtagList,
                imageInfo: imageInfo
            )
        }
    }
    
    func registerLocationSubscriber() {
        
        self.userLocationSubscriber = locationManager.currentLocationPublisher.sink { _ in
        } receiveValue: { coordinate in
            
            self.userPosition = coordinate
            self.userPositionIsAvailable = true
            
            DispatchQueue.main.async {
                
                withAnimation(.linear(duration: 0.5)) {
                    self.isUserAndLatestCenterEqual = false
                }
                
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
       
        guard let currentPos = userPosition else {
            return
        }
        
        self.lastestCenter = currentPos
        
        self.currentCenterPositionOfMap = currentPos
        
        self.isUserAndLatestCenterEqual = true
        
        // 맵의 init, updateUIView순서대로 호출
        self.isLastestCenterAndMapEqual = true
        
        print("실시간 위치, 지도 중심, 가장최근위치 일치")
        
    }
    
    func fetchPotsFromCurrentMapCenter() {
        
        fetchPots(location: currentCenterPositionOfMap)
        
    }
    
    func fetchPots(location: CLLocationCoordinate2D) {
        
        let functionName = #function
        
        Task.detached {
            
            do {
                // 서버로부터 팟을 가져옴
                let potObjects = try await APIRequestGlobalObject.shared.getPots(latitude: location.latitude, longitude: location.longitude, diameter: 500)
                
                await MainActor.run {
                    
                    self.insertPotObjects(objects: potObjects)
                }
                
            } catch {
                
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func showPotRefreshAlert() {
        self.alertTitle = "팟불러오기 실패"
        self.alertMessage = "네트워크 연결 확인 혹은 재시도"
        self.showAlert = true
    }
    
    func addPot(object: PotObject) {
        
        self.potObjects.insert(object)
    }
    
    func removePot(id: Int64) throws {
        
        let countBefore = self.potObjects.count
        
        guard let object = self.potObjects.first(where: { $0.id == id }) else {
            throw SpotPotAnnotationError.removeFailure
        }
                                                
        self.potObjects.remove(object)
        
        if countBefore == potObjects.count {
            throw SpotPotAnnotationError.removeFailure
        }
    }
    
    func updatePotWith(prevId: Int64, object: PotObject) {
        
        do {
            try removePot(id: prevId)
            
            addPot(object: object)
        } catch {
            
            fatalError()
        }
    }
    
    func insertPotObjects(objects: [PotObject]) {
        
        self.potObjects.formUnion(objects)
    }
}

// pot업로드
extension MapScreenComponentModel {
    
    func uploadPot(
        categoryId: Int64,
        content: String,
        hashtagList: [String],
        imageInfo: ImageInformation
    ) {
         
        let dummyPotId: Int64 = -12345
        
        Task.detached {
            do {
                
                guard let location = CJLocationManager.shared.currentUserLocation else {
                    
                    throw PotUploadPrepareError.cantGetUserLocation(function: #function)
                }
                
                let potDTO = SpotPotUploadObject(
                    category: categoryId,
                    text: content,
                    hashtagList: hashtagList,
                    latitude: location.latitude,
                    longitude: location.longitude)
                
                let potObject = PotObject(id: dummyPotId, userId: -1, categoryId: categoryId, content: content, imageKey: nil, expirationDate: "", latitude: location.latitude, longitude: location.longitude)
                
                let uploadedPotObject = try await APIRequestGlobalObject.shared.executePotUpload(imageInfo: imageInfo, uploadObject: potDTO)
                
                await self.addPot(object: uploadedPotObject)
                
            } catch {
                
                print(error, error.localizedDescription)
            }
        }
    }
}
