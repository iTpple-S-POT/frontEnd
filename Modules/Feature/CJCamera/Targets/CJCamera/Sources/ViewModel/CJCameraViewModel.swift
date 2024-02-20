//
//  CJCameraViewModel.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import AVFoundation
import SwiftUI

class CJCameraViewModel: ObservableObject {
    
    private let model: CJCamera
    private let session: AVCaptureSession
    let cameraPreview: AnyView
    
    init() {
        self.session = AVCaptureSession()
        self.model = CJCamera(session: session)
        self.cameraPreview = AnyView(CJCameraPreviewView(captureSession: session))
    }
    
    func configure() {
        model.requestAndCheckPermissions()
    }
    
}
