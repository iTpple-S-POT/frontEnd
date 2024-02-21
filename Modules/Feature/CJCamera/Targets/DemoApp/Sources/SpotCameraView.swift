//
//  SpotCameraView.swift
//  DemoApp
//
//  Created by 최준영 on 2/20/24.
//

import SwiftUI
import Combine
import CJCamera
import DefaultExtensions
import GlobalObjects

extension ShapeStyle where Self == Color {
    
    static var spot_red: Color { Color(hex: "FF533F") }
    
}

enum NavDes {
    case capturedPhotoScreen
}

struct ImageDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let uiImage: UIImage
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Button("돌아가기") {
                    
                    dismiss()
                }
                
                Spacer()
                
            }
            .frame(height: 56)
            .padding(.horizontal, 21)
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
            
        }
        
    }
}


struct SpotCameraView: View {
    @ObservedObject private var viewModel = CJCameraViewModel()
    
    @StateObject private var navController = NavigationController<NavDes>()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        
        viewModel.checkAuthAndExecute()
    }
    
    var body: some View {
        
        NavigationStack(path: $navController.navigationStack) {
            
            // Root
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button {
                        
                        viewModel.positionSwitch()
                        
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .foregroundStyle(.spot_red)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        viewModel.flashSwitch()
                        
                    } label: {
                        Image(systemName: viewModel.isFlashModeOn ? "bolt.fill" : "bolt.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.spot_red)
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
                            .shadow(color: .spot_red, radius: 3)
                    }
                    .disabled(!viewModel.isCameraAvailable)
                    
                        
                    Spacer()
                    
                }
                .frame(height: 100)
                .background(Rectangle().fill(.white))
                .onChange(of: viewModel.currentImage) { _ in
                    navController.addToStack(destination: .capturedPhotoScreen)
                }
            }
            .navigationDestination(for: NavDes.self) { value in
                
                switch value {
                case .capturedPhotoScreen:
                    ImageDetailView(uiImage: viewModel.currentImage!)
                        .navigationBarBackButtonHidden()
                default:
                    fatalError()
                }
            }
        }
    }
}

#Preview {
    SpotCameraView()
}
