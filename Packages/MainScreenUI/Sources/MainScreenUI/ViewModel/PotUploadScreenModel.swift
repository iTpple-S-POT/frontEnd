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
import CJMapkit

// 추후 추가 가능
public enum PotUploadDestination {
    
    case insertText
    
}

public class PotUploadScreenModel: NavigationController<PotUploadDestination> {
    
    @Published private(set) var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    @Published var imageInfo: ImageInformation!
    
    @Published var potText: String = ""
    
    @Published var imageIsSelected: Bool = false
    
    @Published var selectedCollectionType: CollectionTypeObject = .allPhoto
    
    @Published var collectionTypeList: [CollectionTypeObject] = [
        .allPhoto,
        .likedPhtoto
    ]
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    func checkAuthorizationStatus() {
        
        // notDetermined상태인 경우만 권한요청을 보냄
        if authorizationStatus == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                
                DispatchQueue.main.async { self.authorizationStatus = newStatus }
                
            }
            
        }
        
    }
    
    func photoInformationUpdated(imageInfo: ImageInformation) {
        
        self.imageInfo = imageInfo
        
        addToStack(destination: .insertText)
        
    }
    
    func showImageDataUnavailable() {
        
        showAlert = true
        alertTitle = "사용할 수 없는 이미지"
        alertMessage = "다른 이미지를 선택해주세요."
    }
    
}

enum PotUploadPrepareError: Error {
    
    case cantGetUserLocation
    
}

// MARK: - 팟 업로드용 데이터
extension PotUploadScreenModel {
    
    func uploadPot() throws {
        
        guard let location = CJLocationManager.shared.currentUserLocation else {
            
            throw PotUploadPrepareError.cantGetUserLocation
        }
        
        // TODO: 카테고리 업데이트
        let object = SpotPotUploadObject(category: 0, text: potText, latitude: location.latitude, longitude: location.longitude)
        
        APIRequestGlobalObject.shared.uploadPot(imageInfo: imageInfo, uploadObject: object)
        
        
    }
    
}
