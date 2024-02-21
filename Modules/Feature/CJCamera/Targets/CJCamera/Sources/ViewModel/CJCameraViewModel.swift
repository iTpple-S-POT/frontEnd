//
//  CJCameraViewModel.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import AVFoundation
import SwiftUI
import Combine

public class CJCameraViewModel: ObservableObject {
    
    private let model: CJCamera?
    private let session: AVCaptureSession
    public private(set) var cameraPreview: AnyView?
    
    // Camera options
    @Published public private(set) var isCameraAvailable = false
    @Published public var isFlashModeOn = false
    
    let hapticImpact = UIImpactFeedbackGenerator()
    
    // current photo
    @Published public var currentImage: UIImage?
    
    // Combine
    private var subscriptions: Set<AnyCancellable> = []
    
    public init() {
        
        self.session = AVCaptureSession()
        self.model = CJCamera(session: session)
        
        if model == nil { self.cameraPreview = nil }
        else { self.cameraPreview = AnyView(CJCameraPreviewView(captureSession: session)) }
        
        // set publisher
        model?
            .$currentImage
            .receive(on: DispatchQueue.main)
            .sink { result in
                
                switch result {
                case .finished:
                    print("카메라 구독 종료")
                case .failure(let error):
                    preconditionFailure(error.localizedDescription)
                }
                
            } receiveValue: { image in
                
                self.currentImage = image
            }
            .store(in: &subscriptions)
        
        model?
            .$isCameraAvailable
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.isCameraAvailable = result
            }
            .store(in: &subscriptions)
        
        hapticImpact.prepare()
    }
    
    public func checkAuthAndExecute() {
        
        model?.requestAndCheckPermissions()
    }
    
    public func flashSwitch() {
        
        isFlashModeOn.toggle()
        
        model?.flashMode = isFlashModeOn ? .on : .off
    }
    
    public func positionSwitch() {
        
        model?.flipCamera()
    }
}


// MARK: - Action
public extension CJCameraViewModel {
    
    func takePhoto() {
        hapticImpact.impactOccurred()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.model?.capturePhoto()
        }
    }
    
}
