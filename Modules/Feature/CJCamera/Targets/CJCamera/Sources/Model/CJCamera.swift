//
//  CJCamera.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import AVFoundation

// Input을 다루는 부분
class CJCamera {
    
    var session: AVCaptureSession
    var input: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    enum CJCameraError: Error {
        case cantGetCertainDevice
        case cantAddInput
        case cantAddOutput
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
            
            DispatchQueue.main.async {
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
