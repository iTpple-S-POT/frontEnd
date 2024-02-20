import SwiftUI

public struct TestCameraView: View {
    
    @StateObject private var viewModel = CJCameraViewModel()
    
    public init() { }
    
    public var body: some View {
        ZStack {
            
            viewModel.cameraPreview
                .onAppear(perform: {
                    
                    viewModel.configure()
                })
        }
    }
}
