//
//  PotDownloadViewModel.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import SwiftUI
import GlobalObjects
import DefaultExtensions
import Combine

class MapPotController: ObservableObject {
    
    @Published var potViewModels: Set<PotViewModel> = []
    
    public var locationVMForCurrentUser: LocationViewModel = .default
    private var locationVMForMapCenter: LocationViewModel = .default
    
    private let potFetcher: PotFetcher
    
    private let locationFetcher: LocationFetcher
    
    private var isInitialRequest = true
    
    init(potFetcher: PotFetcher, locationFetcher: LocationFetcher) {
        self.potFetcher = potFetcher
        self.locationFetcher = locationFetcher
        
        setNotification()
        
        setSubscription()
        
        startRequestLocation()
    }
    
    func setNotification() {
        
        NotificationCenter.potMapCenter.addObserver(self, selector: #selector(potUploadAction(_:)), name: .potUpload, object: nil)
        
        NotificationCenter.potMapCenter.addObserver(self, selector: #selector(whenUserMoveTheMapCallback(_:)), name: .whenUserMoveTheMap, object: nil)
    }
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func setSubscription() {
        
        locationFetcher.locationPublisher
            .sink { locVm in
                
                self.locationVMForCurrentUser = locVm
                
                if self.isInitialRequest {
                    
                    self.isInitialRequest = false
                    
                    self.locationVMForMapCenter = locVm
                    
                    self.moveMapToCurrentUserLocation()
                    
                    self.requestPots()
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func whenUserMoveTheMapCallback(_ notification: Notification) {
        
        guard let coordinate = notification.object as? [String: CGFloat] else { return }
        
        let lat = coordinate["latitude"]!
        let lon = coordinate["longitude"]!
        
        let model = LocationModel(latitude: lat, longitude: lon)
        
        self.locationVMForMapCenter = LocationViewModel(model: model)
    }
    
    @objc
    func potUploadAction(_ notification: Notification) {
        
        if let objects = notification.object as? [String: Any] {
            
            let categoryId = objects["categoryId"] as! Int64
            let content = objects["content"] as! String
            let hashtagList = objects["hashtagList"] as! [Int64]
            let imageInfo = objects["imageInfo"] as! ImageInformation
            
            self.uploadPot(
                categoryId: categoryId,
                content: content,
                hashtagList: hashtagList,
                imageInfo: imageInfo
            )
        }
    }
    
    func requestPots() {
        
        if !locationFetcher.isAuthorizationValid {
            
            NotificationCenter.potMapCenter.post(name: .needsOptionSettingForLocation, object: nil)
            
            return
        }
        
        print("팟 요청 위치: \(locationVMForMapCenter.getCLCoordinate2D())")
        
        potFetcher.requestPotsBasedOn(location: locationVMForMapCenter.model) { result in
            
            switch result {
            case .success(let potViewModels):
                
                DispatchQueue.main.async {
                    
                    self.appendPotViewModels(vms: potViewModels)
                }
            case .failure(let failure):
                
                print("팟 요청 실패: \(failure)")
            }
        }
    }
    
    func startRequestLocation() {
        
        do {
            
            try locationFetcher.reqeustCurrentUserLocation()
            
        } catch {
            
            if let locError = error as? LocationFetcherError {
                
                if locError == .needsAuthInSetting {
                    
                    // 세팅에서 변경이 필요
                    NotificationCenter.potMapCenter.post(name: .needsOptionSettingForLocation, object: nil)
                }
            }
        }
    }
    
    func moveMapToCurrentUserLocation() {
        
        if !locationFetcher.isAuthorizationValid {
            
            NotificationCenter.potMapCenter.post(name: .needsOptionSettingForLocation, object: nil)
            
            return
        }
        
        let object: [String: CGFloat] = [
            "latitude": locationVMForCurrentUser.model.latitude,
            "longitude": locationVMForCurrentUser.model.longitude
        ]
        
        NotificationCenter.potMapCenter.post(name: .moveMapCenterToSpecificLocation, object: object)
        
    }
}

extension MapPotController {
    
    func uploadPot(
        categoryId: Int64,
        content: String,
        hashtagList: [Int64],
        imageInfo: ImageInformation
    ) {
        
        if !locationFetcher.isAuthorizationValid {
            
            NotificationCenter.potMapCenter.post(name: .needsOptionSettingForLocation, object: nil)
            
            return
        }
        
        let potDTO = SpotPotUploadObject(
            category: categoryId,
            text: content,
            hashtagList: hashtagList,
            latitude: locationVMForMapCenter.model.latitude,
            longitude: locationVMForMapCenter.model.longitude)
        
        Task.detached {
            
            do {
                
                let uploadedPotObject = try await APIRequestGlobalObject.shared.executePotUpload(imageInfo: imageInfo, uploadObject: potDTO)
                
                //업로드 성공
                let model = PotModel.makePotModelFrom(potObject: uploadedPotObject)
                
                let vm = PotViewModel(model: model)
                
                await self.appendPotViewModel(vm: vm)
                
            } catch {
                
                print(error, error.localizedDescription)
            }
        }
        
    }
    
    @MainActor
    func appendPotViewModel(vm: PotViewModel) {
        
        potViewModels.insert(vm)
    }
    
    @MainActor
    func appendPotViewModels(vms: [PotViewModel]) {
        
        potViewModels.formUnion(vms)
    }
}
