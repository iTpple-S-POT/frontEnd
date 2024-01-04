//
//  PotUploadScreenModel.swift
//
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection
import GlobalObjects

internal enum DestinationSC {
    
    case insertText
    
}

class PotUploadScreenModel: NavigationController<DestinationSC> {
    
    @Published private(set) var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    @Published var potUploadData: PotUploadDataModel = PotUploadDataModel()
    
    @Published var imageIsSelected: Bool = false
    
    func checkAuthorizationStatus() {
        
        // notDetermined상태인 경우만 권한요청을 보냄
        if authorizationStatus == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                
                DispatchQueue.main.async { self.authorizationStatus = newStatus }
                
            }
            
        }
        
    }
    
    func photoInformationUpdated(info: ImageInformation?) {
        
        potUploadData.imageInformation = info
        
        addToStack(destination: .insertText)
        
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
