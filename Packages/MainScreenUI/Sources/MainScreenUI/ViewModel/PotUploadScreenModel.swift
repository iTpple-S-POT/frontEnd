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

public enum PotUploadDestination {
    
    case insertText
    
}

public enum SelectPhotoError: Error {
    
    case dataUnavailableForPhoto
    
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
    
    func photoInformationUpdated(imageInfo: ImageInformation?) throws {
        
        if imageInfo != nil {
            
            self.imageInfo = imageInfo
            
            addToStack(destination: .insertText)
            
        } else {
            
            throw SelectPhotoError.dataUnavailableForPhoto
        }
        
    }
    
    func showImageDataUnavailable() {
        
        showAlert = true
        alertTitle = "사용할 수 없는 이미지"
        alertMessage = "다른 이미지를 선택해주세요."
    }
    
}


// MARK: - 팟 업로드용 데이터
extension PotUploadScreenModel {
    
    
    
}
