import SwiftUI

public struct TestCameraView: View {
    
    @StateObject private var viewModel = CJCameraViewModel()
    
    public init() { }
    
    public var body: some View {
        ZStack {
            
            // 카메라 프리뷰
            viewModel.cameraPreview
                .onAppear(perform: {
                    
                    viewModel.configure()
                })
            
            
        }
    }
}


