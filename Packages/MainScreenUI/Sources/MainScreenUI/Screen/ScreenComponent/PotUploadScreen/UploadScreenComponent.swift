//
//  UploadScreenComponent.swift
//
//
//  Created by 최준영 on 2024/01/13.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents
import DefaultExtensions

struct UploadScreenComponent: View {
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    @EnvironmentObject var globalObject: GlobalStateObject
    
    @FocusState var focusState
    
    let textFieldPHString = "당신의 이야기를 자유롭게 들려주세요"
    
    var selectedUIImage: UIImage? {
        
        if let imageInfo = screenModelWithNav.imageInfo, let uiImage = UIImage(data: imageInfo.data) { return uiImage }
            
        return nil
    }
    
    var cameraView: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(.btn_light_grey)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.midium_gray, lineWidth: 1)
                Image.makeImageFromBundle(bundle: .module, name: "Camera", ext: .png)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56)
            })
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            SpotNavigationBarView(title: "업로드") {
                
                print("AA")
                
                screenModelWithNav.popTopView()
                
            }
            
            // 카메라 or 사진
            ZStack {
                
                cameraView
                    .onTapGesture { screenModelWithNav.showSelectPhotoView = true }
                    .zIndex(0)
                
                if let uiImage = selectedUIImage {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .zIndex(1)
                    
                }
            }
            .frame(height: 158)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(RoundedRectangle(cornerRadius: 10)) // !! contentShape를 clippedShape뒤로
            .overlay(content: {
                
                if selectedUIImage != nil {
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Image.makeImageFromBundle(bundle: .module, name: "NotePencil", ext: .png)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .padding(10)
                                .onTapGesture { screenModelWithNav.showSelectPhotoView = true }
                        }
                    }
                }
            })
            .padding(.top, 40)
            .padding(.horizontal, 21)
            
            Rectangle()
                .fill(.btn_light_grey)
                .frame(height: 1)
                .padding(.top, 40)
            
            // 해시테그
            HStack {
                
                Text("#해시 태그")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.midium_gray)
                
                Spacer()
                
            }
            .frame(height: 56)
            .padding(.horizontal, 21)
            
            Rectangle()
                .fill(.btn_light_grey)
                .frame(height: 1)
                .padding(.top, 10)
            
            
            // 텍스트
            TextField("", text: $screenModelWithNav.potText, axis: .vertical)
                .textFieldStyle(TappableTextFieldStyle(verPadding: 14, horPadding: 0))
                .placeholder(when: screenModelWithNav.potText.isEmpty, placeholder: {
                    Text(textFieldPHString)
                        .foregroundStyle(.midium_gray)
                })
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.horizontal, 21)
                .focused($focusState)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            
                            Spacer()
                            
                            Button("입력 완료") {  focusState = false }
                                .padding(.trailing, 10)
                        }
                    }
                }
            
            Spacer(minLength: 0)
            
            // 다음
            SpotRoundedButton(text: "다음", color: .btn_red_nt) {
                
                //
                
            }
            .padding(.horizontal, 21)
            .padding(.bottom, 24)
            
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $screenModelWithNav.showSelectPhotoView) {
            
            SelectPhotoView()
            
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct TappableTextFieldStyle: TextFieldStyle {
    
    @FocusState private var textFieldFocused: Bool
    
    var verPadding: CGFloat
    
    var horPadding: CGFloat
    
    init(verPadding: CGFloat, horPadding: CGFloat) {
        self.verPadding = verPadding
        self.horPadding = horPadding
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, verPadding)
            .padding(.horizontal, horPadding)
            .focused($textFieldFocused)
            .onTapGesture { textFieldFocused = true }
    }
    
}

#Preview {
    UploadScreenComponent()
        .environmentObject(PotUploadScreenModel())
        .environmentObject(GlobalStateObject())
}
