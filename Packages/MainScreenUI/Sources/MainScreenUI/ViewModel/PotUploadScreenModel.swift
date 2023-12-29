//
//  PotUploadScreenModel.swift
//
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection

internal enum DestinationSC {
    
    case selectPhotoSc
    case editPotSC
    
}

class PotUploadScreenModel: NavigationController<DestinationSC> {
    
    @Published private(set) var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    @Published var photoInfo: ImageInformation?
    
    func checkAuthorizationStatus() {
        
        // notDetermined상태인 경우만 권한요청을 보냄
        if authorizationStatus == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                
                DispatchQueue.main.async { self.authorizationStatus = newStatus }
                
            }
            
        }
        
    }
    
    func photoInformationUpdated(info: ImageInformation?) {
        
        photoInfo = info
        
        addToStack(destination: .editPotSC)
        
    }
    
}


class NavigationController<Destination>: ObservableObject {
    @Published var navigationStack: [Destination] = []

    func presentScreen(destination: Destination) {
        navigationStack = [destination]
    }
    
    func addToStack(destination: Destination) {
        navigationStack.append(destination)
    }
    
    func popTopView() {
        let _ = navigationStack.popLast()
    }
    
    func clearStack() {
        navigationStack = []
    }
}
