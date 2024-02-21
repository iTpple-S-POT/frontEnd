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
    
    private let model: CJCamera
    private let session: AVCaptureSession
    public let cameraPreview: AnyView
    
    // Camera options
    @Published public var isFlashModeOn = false
    
    // current photo
    @Published public var currentImage: UIImage?
    
    // Combine
    private var subscriptions: Set<AnyCancellable> = []
    
    public init() {
        
        self.session = AVCaptureSession()
        self.model = CJCamera(session: session)
        self.cameraPreview = AnyView(CJCameraPreviewView(captureSession: session))
        
        // set publisher
        model
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

    }
    
    public func configure() {
        model.requestAndCheckPermissions()
    }
    
    public func flashSwitch() {
        
        
    }
}


// MARK: - Action
public extension CJCameraViewModel {
    
    func takePhoto() {
        
        model.capturePhoto()
    }
    
}
