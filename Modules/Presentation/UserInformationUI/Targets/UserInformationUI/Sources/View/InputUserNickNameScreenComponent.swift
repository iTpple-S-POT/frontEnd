//
//  NickNameInputView.swift
//
//
//  Created by 최준영 on 2023/11/22.
//

import SwiftUI
import GlobalFonts
import DefaultExtensions
import GlobalUIComponents

struct InputUserNickNameScreenComponent: View {
    
    @EnvironmentObject var screenModel: ConfigurationScreenModel
    
    var xCircleImage: Image {
        let fileName = "XCircle"
        let fileExtension = "png"
        let path = Bundle.module.provideFilePath(name: fileName, ext: fileExtension)
        
        guard let uiImage = UIImage(named: path) else {
            preconditionFailure("\(fileName).\(fileExtension)를 UIImage타입으로 변환 불가")
        }
        
        return Image(uiImage: uiImage)
    }
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            // Title1
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("안녕하세요!")
                    (
                        Text("사용하실 ")
                        +
                        Text("닉네임 ")
                            .font(.suite(type: .SUITE_SemiBold, size: 28))
                        +
                        Text("입력해주세요")
                    )
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                .frame(height: 75)
                
                Spacer()
            }
            
            // Title2
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("공백없이 15자 이하로 작성해주세요")
                    Text("특수문자는 _만 사용 가능해요 :)")
                }
                .font(.suite(type: .SUITE_Light, size: 16))
                .frame(height: 45)
                
                Spacer()
            }
            .padding(.top, 6)
            
            
            // Input space
            VStack(spacing: 0) {
                
                Spacer()
                
                // 상단
                HStack(spacing: 0) {
                    TextField(text: $screenModel.nickNameInputString) {
                        Text("닉네임을 입력해주세요")
                            .font(.suite(type: .SUITE_Light, size: 19.5))
                            .foregroundStyle(.grayForText)
                    }
                    .font(.suite(type: .SUITE_Light, size: 19.5))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .frame(height: 22)
                    .onChange(of: screenModel.nickNameInputString) { _ in
                        
                        screenModel.dontMoveOnToNext()
                    }
                    
                    
                    Spacer()
                    
                    // 텍스트를 지우는 버튼
                    Group {
                        if !screenModel.isStringEmpty {
                            Button {
                                screenModel.makeNickNameInputStringEmpty()
                            } label: {
                                xCircleImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(2.25)
                                    .frame(width: 24, height: 24)
                            }
                            .transition(.scale)
                        }
                    }
                    .animation(.easeIn, value: screenModel.isStringEmpty)
                    
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 14)
                }
                .frame(height: 24)
                
                Spacer()
                
                // 하단 바
                Rectangle()
                    .fill(screenModel.isNickNameInvalid ? .spotRed : .black)
                    .frame(height: 1)
            }
            .frame(height: 42)
            .padding(.top, 24)
            
            
            // Validation Text
            HStack {
                Group {
                    if screenModel.isNickNameInvalid {
                        Text("사용할 수 없는 닉네임 입니다.")
                            .foregroundStyle(.spotRed)
                    }
                    
                    if screenModel.isNickNameValid {
                        Text("멋진 닉네임이에요 :)")
                            .foregroundStyle(.black)
                    }
                }
                .font(.suite(type: .SUITE_Regular, size: 14))
                
                
                Spacer()
            }
            .frame(height: 17)
            .padding(.top, 8)
            
            Spacer()
        }
    }
}

/// SettingView들의 기본 레이아웃을 제공하는 프리뷰 입니다.
internal struct PreviewForProcessView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.defaultBackgroundColor
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.red)
                    .frame(height: 42)
                Rectangle()
                    .fill(.orange)
                    .frame(height: 28)
                Rectangle()
                    .fill(.yellow)
                    .frame(height: 30)
                content
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .background(Rectangle().fill(.cyan))
        .background(Rectangle().fill(.indigo).ignoresSafeArea())
    }
}

#Preview {
    InputUserNickNameScreenComponent()
        .environmentObject(ConfigurationScreenModel())
}
