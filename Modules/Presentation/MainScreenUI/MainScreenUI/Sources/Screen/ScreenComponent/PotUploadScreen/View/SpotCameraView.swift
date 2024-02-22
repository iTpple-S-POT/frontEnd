//
//  SpotCameraView.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/22/24.
//

import SwiftUI
import CJCamera
import Combine
import GlobalObjects

struct ImageDetailView: View {
    
    @EnvironmentObject private var screenModel: PotUploadScreenModel
    @ObservedObject var cameraViewModel: CJCameraViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    let onDismiss: () -> Void
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                    .onTapGesture(perform: {
                        onDismiss()
                        dismiss()
                    })
                    .padding(.horizontal, 10)
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        
                        if let uiImage = cameraViewModel.currentImage, let data = uiImage.pngData() {
                            
                            let imageInfo = ImageInformation(data: data, ext: "png")
                            
                            screenModel.photoInformationUpdated(imageInfo: imageInfo)
                        }
                        
                        dismiss()
                        screenModel.popTopView()
                    }
            
            }
            .foregroundStyle(.mainScreenRed)
            .frame(height: 56)
            .padding(.horizontal, 21)
            
            Image(uiImage: cameraViewModel.currentImage ?? UIImage(systemName: "questionmark")!)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all, edges: .bottom)
            
            Spacer(minLength: 0)
        }
        
    }
}

fileprivate enum CameraDestination {
    case capturePreview
}

struct SpotCameraView: View {
    
    @StateObject private var navModel = NavigationController<CameraDestination>()
    
    @StateObject private var viewModel = CJCameraViewModel()
    
    @State private var captureBtnDisabled = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        // Root
        NavigationStack(path: $navModel.navigationStack) {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.mainScreenRed)
                        .frame(height: 22)
                        .padding(.horizontal, 10)
                        .onTapGesture(perform: { dismiss() })
                    
                    Spacer()
                    
                    Button {
                        
                        viewModel.positionSwitch()
                        
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .foregroundStyle(.mainScreenRed)
                    }
                }
                .frame(height: 56)
                .background(Rectangle().fill(.white))
                .padding(.horizontal, 21)
                
                GeometryReader { geo in
                    
                    viewModel.cameraPreview
                        .frame(width: geo.size.width, height: geo.size.height)
                        .position(x: geo.size.width/2, y: geo.size.height/2)
                    
                }
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        captureBtnDisabled = true
                        
                        viewModel.takePhoto()
                        
                    } label: {
                        
                        Circle()
                            .strokeBorder(.white, lineWidth: 4)
                            .overlay {
                                Circle()
                                    .fill(.white)
                                    .padding(8)
                                    .shadow(color: .clear, radius: 0)
                            }
                            .frame(width: 64)
                            .contentShape(Circle())
                            .shadow(color: .mainScreenRed, radius: 3)
                    }
                    .disabled(captureBtnDisabled || !viewModel.isCameraAvailable)
                    
                    
                    Spacer()
                    
                }
                .frame(height: 100)
                .background(Rectangle().fill(.white))
                .onChange(of: viewModel.currentImage) { value in
                    
                    navModel.addToStack(destination: .capturePreview)
                }
            }
            .navigationDestination(for: CameraDestination.self) { value in
                switch value {
                case .capturePreview:
                    ImageDetailView(cameraViewModel: viewModel) {
                        
                        captureBtnDisabled = false
                    }
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .onAppear {
            
            viewModel.checkAuthAndExecute()
        }
    }
}
