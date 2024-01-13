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
    
    case uploadScreen
    case hashTagScreen
    case finalScreen
    
}

public class PotUploadScreenModel: NavigationController<PotUploadDestination> {
    
    // 카테고리
    @Published var selectedCategoryId: Int64?
    
    // 이미지
    @Published var showSelectPhotoView = false
    
    @Published private(set) var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    @Published private(set) var imageInfo: ImageInformation?
    
    @Published var imageIsSelected: Bool = false
    
    @Published var selectedCollectionType: CollectionTypeObject = .allPhoto
    
    @Published var collectionTypeList: [CollectionTypeObject] = [
        .allPhoto,
        .likedPhtoto
    ]
    
    // 팟 텍스트
    @Published var potText: String = ""
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    var dismiss: DismissAction?
    
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
        
    }
    
}

// MARK: - 팟 업로드용 데이터
extension PotUploadScreenModel {
    
    func uploadPot() async throws {
        
        guard let location = CJLocationManager.shared.currentUserLocation else {
            
            throw PotUploadPrepareError.cantGetUserLocation(function: #function)
        }
        
        // TODO: 카테고리 업데이트
        let object = SpotPotUploadObject(category: 1, text: potText, latitude: location.latitude, longitude: location.longitude)
        
        guard let imageInfo_unwrapped = imageInfo else {
            
            throw PotUploadPrepareError.imageInfoDoesntExist(function: #function)
        }
                
        try await APIRequestGlobalObject.shared.executePotUpload(imageInfo: imageInfo_unwrapped, uploadObject: object)
    }
    
}


// MARK: - Alert
extension PotUploadScreenModel {
    
    func showImageDataUnavailable() {
        
        showAlert = true
        alertTitle = "사용할 수 없는 이미지"
        alertMessage = "다른 이미지를 선택해주세요"
    }
    
    func showImageDoesntLoaded() {
        
        showAlert = true
        alertTitle = "이미지가 로드되지 않음"
        alertMessage = "잠시만 기다려 주세요"
    }
    
    func showLocationAuthorizationError() {
        
        showAlert = true
        alertTitle = "위치정보를 얻을 수 없습니다"
        alertMessage = "설정 > SPOT 위치정보에 동의해 주세요"
    }
    
    func showNetworkError(errorCase: SpotNetworkError) {
        
        showAlert = true
        alertTitle = "네트워크 에러"
        
        switch errorCase {
        case .serverError(_):
            alertMessage = "SPOT서버가 불안정합니다."
        default:
            alertMessage = "업로드 과정에서 문제가 발생했습니다."
        }
        
    }
    
}
