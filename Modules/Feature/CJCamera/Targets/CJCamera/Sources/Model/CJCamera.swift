//
//  CJCamera.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import AVFoundation
import SwiftUI

public enum CJCameraError: Error {
    case cantGetCertainDevice
    case cantAddInput
    case cantAddOutput
    case cantMakeDataToUIImage
}

// Input을 다루는 부분
class CJCamera: NSObject, ObservableObject {
    
    var session: AVCaptureSession
    var input: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    
    // 촬영관련
    var photoData = Data(count: 0)
    private var isProcessing = false
    @Published var currentImage: UIImage?
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func setUpSession() {
        
        do {
            
            // Device
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                throw CJCameraError.cantGetCertainDevice
            }
            
            input = try AVCaptureDeviceInput(device: device)
            
            // Input
            guard session.canAddInput(input) else {
                throw CJCameraError.cantAddInput
            }
            
            session.addInput(input)
            
            // OutPut
            guard session.canAddOutput(output) else {
                throw CJCameraError.cantAddOutput
            }
            
            session.addOutput(output)
            output.maxPhotoQualityPrioritization = .quality
            
            DispatchQueue.global().async {
                self.session.startRunning()
            }
        } catch {
            
            print("세션 셋업 실패: \(error.localizedDescription)")
        }
        
    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpSession()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpSession()
        default:
            // 거절했을 경우
            print("Permession declined")
        }
    }
}


// MARK: - 사진촬영
extension CJCamera {
    
    /// 촬영 실행
    func capturePhoto() {
        
        if isProcessing { return }
        
        isProcessing = true
        
        let photoSettings = AVCapturePhotoSettings()
        
        self.output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func saveCapturedPhoto(_ imageData: Data) throws {
        
        guard let uiImage = UIImage(data: imageData) else {
            throw CJCameraError.cantMakeDataToUIImage
        }
        
        // 모델 프로퍼티에 값 할당
        self.currentImage = uiImage
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
    
    
}

extension CJCamera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        isProcessing = false
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        // TODO: 사진저장에 실패하는 경우
        try? self.saveCapturedPhoto(imageData)
    }
}
