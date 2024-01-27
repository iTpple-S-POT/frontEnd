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
import Combine


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
    
    // 해쉬 테그
    typealias HashTag = String
    
    @Published var temporalHashTagString = ""
    @Published private(set) var potHashTags: [HashTag] = []
    
    // 팟 텍스트
    @Published var potText: String = ""
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    let potUploadPublisher = PassthroughSubject<Bool, Never>()
    
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
public extension PotUploadScreenModel {
    
    func uploadPot() {
        
        let categoryId = self.selectedCategoryId!
        
        let content = self.potText
        
        let imageInfo = self.imageInfo
         
        Task.detached {
            do {
                
                guard let location = CJLocationManager.shared.currentUserLocation else {
                    
                    throw PotUploadPrepareError.cantGetUserLocation(function: #function)
                }
                
                let object = SpotPotUploadObject(category: categoryId, text: content, latitude: location.latitude, longitude: location.longitude)
                
                guard let imageInfo_unwrapped = imageInfo else {
                    
                    throw PotUploadPrepareError.imageInfoDoesntExist(function: #function)
                }
                
                // dummy생성
                try await SpotStorage.default.makeDummyPot(object: object, imageData: imageInfo_unwrapped.data)
                
                print("낙관적 팟 생성완료")
                
                let uploadedPotObject = try await APIRequestGlobalObject.shared.executePotUpload(imageInfo: imageInfo_unwrapped, uploadObject: object)
                
                // dummy업데이트
                do {
                    
                    try await SpotStorage.default.updateDummyPot(object: uploadedPotObject)
                    
                    print("낙관적 팟 업데이트 성공")
                }
                catch {
                    
                    print(error.localizedDescription)
                    
                    print("낙관적 팟 업데이트 실패")
                    
                    self.potUploadPublisher.send(false)
                    
                    // dummy제거
                    do {
                        try await SpotStorage.default.deleteDummyPot()
                    } catch {
                        print("낙관적 팟 제거 실패: \(error.localizedDescription)")
                    }
                }
                
            } catch {
                
                print(error, error.localizedDescription)
                
                // Alert표시를 위한 퍼블리쉬
                self.potUploadPublisher.send(false)
                
                // dummy제거
                do {
                    try await SpotStorage.default.deleteDummyPot()
                } catch {
                    print("낙관적 팟 제거 실패: \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    /// 최종 화면으로 이동할 수 있는가?
    var isReadyToUpload: Bool {
        
        imageInfo != nil && selectedCategoryId != nil
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
    
    func showDuplicateHashTag() {
        
        showAlert = true
        alertTitle = "해쉬테그 중복"
        alertMessage = "이미 추가된 해쉬태그 입니다"
    }
    
}


// MARK: - HashTag
extension PotUploadScreenModel {
    
    func submitHashTag() {
        
        if !temporalHashTagString.isEmpty {
                
            let hashTagStr = temporalHashTagString
            
            if !checkTagAlreadyExists(element: hashTagStr) {
                
                // 해쉬테그 삽입
                insertHashTag(element: hashTagStr)
                
                // 문자열 초기화
                temporalHashTagString = ""
            } else {
                
                showDuplicateHashTag()
                
            }
        }
    }
    
    func checkTagAlreadyExists(element: HashTag) -> Bool {
        
        potHashTags.contains(element)
    }
    
    func removeHashTag(index: Int) {
        
        potHashTags.remove(at: index)
    }
    
    func insertHashTag(element: HashTag) {
        
        potHashTags.append(element)
    }
    
}
