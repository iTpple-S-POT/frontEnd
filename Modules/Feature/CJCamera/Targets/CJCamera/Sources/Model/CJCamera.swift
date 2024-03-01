//
//  CJCamera.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import AVFoundation
import SwiftUI

public enum CJCameraError: Error {
    case inputNotAvailable
    case cantGetCertainDevice
    case cantAddInput
    case cantAddOutput
    case cantMakeDataToUIImage
}

public enum CameraInputState {
    
    case frontOnly
    case backOnly
    case frontAndBack
    case neither
}

// Input을 다루는 부분
class CJCamera: NSObject, ObservableObject {
    
    var session = AVCaptureSession()
    
    var frontCameraInput: AVCaptureDeviceInput!
    var backCameraInput: AVCaptureDeviceInput!
    
    let output = AVCapturePhotoOutput()
    
    var state: CameraInputState = .frontAndBack
    
    private var isInitial = true
    
    // 촬영관련
    var photoData = Data(count: 0)
    @Published private(set) var isCameraAvailable = false
    @Published var currentImage: UIImage?
    
    // 촬영 옵션
    var flashMode: AVCaptureDevice.FlashMode = .off
    private var currentPosition: AVCaptureDevice.Position = .back
    
    init?(session: AVCaptureSession) {
        super.init()
        
        self.session = session
        
        if !setInputs() { return nil }
    }
    
    func setInputs() -> Bool {
        var front = false
        var back = false
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back), let input = try? AVCaptureDeviceInput(device: device) {
            
            self.backCameraInput = input
            
            front = session.canAddInput(input)
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front), let input = try? AVCaptureDeviceInput(device: device) {
            
            self.frontCameraInput = input
            
            back = session.canAddInput(input)
        }
        
        if front, back { self.state = .frontAndBack }
        else if front { self.state = .frontOnly }
        else if back { self.state = .backOnly }
        else { self.state = .neither }
        
        return self.state != .neither
    }
    
    func setUpInitialSession() {
        
        if !isInitial { return }
        
        isInitial = false
        
        do {
            
            if state == .frontOnly {
                currentPosition = .front
                
                session.addInput(frontCameraInput)
                
            } else {
                currentPosition = .back
                
                session.addInput(backCameraInput)
            }
            
            guard session.canAddOutput(output) else {
                throw CJCameraError.cantAddOutput
            }
            
            session.addOutput(output)
            
            DispatchQueue.global().async {
                self.session.startRunning()
                self.isCameraAvailable = true
            }
        } catch {
            
            print("session초기화 세팅중 오류 발생: \(error)")
        }
    }
    
    private func addInputToSession(input: AVCaptureInput) {
        
        guard session.canAddInput(input) else { return }
        
        session.addInput(input)
        
        session.commitConfiguration()
    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpInitialSession()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpInitialSession()
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
        
        if !isCameraAvailable { return }
        
        isCameraAvailable = false
        
        let photoSettings = AVCapturePhotoSettings()
        
//        photoSettings.flashMode = self.flashMode
        
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
    
    // 화면 모드
    func flipCamera() {
        
        guard state == .frontAndBack else { return }
        
        self.isCameraAvailable = false
        
        session.stopRunning()
        session.beginConfiguration()

        if currentPosition == .back {
            
            currentPosition = .front
                
            session.removeInput(backCameraInput)
            session.addInput(frontCameraInput)
            
            output.connections.first?.isVideoMirrored = true
        } else {
            
            currentPosition = .back
            
            session.removeInput(frontCameraInput)
            session.addInput(backCameraInput)
            
            output.connections.first?.isVideoMirrored = false
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global().async {
            self.session.startRunning()
            self.isCameraAvailable = true
        }
    }
}

extension CJCamera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        session.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        isCameraAvailable = true

        guard let imageData = photo.fileDataRepresentation() else { return }
        
        try? self.saveCapturedPhoto(imageData)
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
}
