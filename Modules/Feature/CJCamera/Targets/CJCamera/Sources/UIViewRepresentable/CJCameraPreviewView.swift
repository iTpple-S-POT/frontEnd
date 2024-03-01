//
//  CJCameraPreviewView.swift
//  CJCamera
//
//  Created by 최준영 on 2/20/24.
//

import SwiftUI
import UIKit
import AVFoundation


// MARK: - View
class VideoPreviewView: UIView {
    
    typealias Layer = AVCaptureVideoPreviewLayer
    
    override class var layerClass: AnyClass {
        Layer.self
    }
    
    var videoPreviewLayer: Layer {
        
        return layer as! Layer
    }
    
}

class CJCameraPreViewCoordinator: NSObject {
    
}

struct CJCameraPreviewView: UIViewRepresentable {
    
    var captureSession: AVCaptureSession
    
    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    func makeUIView(context: Context) -> VideoPreviewView {
        
        let view = VideoPreviewView()
        
        view.backgroundColor = .white
        
        let layer = view.videoPreviewLayer
        
        layer.videoGravity = .resizeAspectFill
        layer.cornerRadius = 0
        layer.session = self.captureSession
        layer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
    
    func makeCoordinator() -> CoordinatorType {
        CoordinatorType()
    }
    
    typealias UIViewType = VideoPreviewView
    typealias CoordinatorType = CJCameraPreViewCoordinator
}
