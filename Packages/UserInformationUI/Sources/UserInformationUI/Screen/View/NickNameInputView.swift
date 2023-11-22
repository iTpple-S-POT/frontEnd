//
//  NickNameInputView.swift
//
//
//  Created by 최준영 on 2023/11/22.
//

import SwiftUI
import GlobalFonts
import DefaultExtensions

struct NickNameInputView: View {
    
    @StateObject private var viewModel = NickNameInputViewModel()
    
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
                VStack(alignment: .leading) {
                    Text("안녕하세요!")
                    (
                        Text("사용하실 ")
                        +
                        Text("닉네임 ")
                            .font(.suite(type: .SUITE_SemiBold, size: 30))
                        +
                        Text("입력해주세요")
                    )
                }
                .font(.suite(type: .SUITE_Regular, size: 30))
                .frame(height: 75)
                
                Spacer()
            }
            
            // Title2
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("공백없이 15자 이하로 작성해주세요")
                    Text("특수문자는 _만 사용 가능해요 :)")
                }
                .font(.suite(type: .SUITE_Light, size: 15))
                .frame(height: 45)
                
                Spacer()
            }
            .padding(.top, 3)
            
            
            // Input space
            VStack(spacing: 0) {
                
                Spacer()
                
                HStack(spacing: 0) {
                    TextField(text: $viewModel.nickNameInputString) {
                        Text("닉네임을 입력해주세요")
                            .font(.suite(type: .SUITE_Light, size: 19.5))
                            .foregroundStyle(.greyForText)
                    }
                    .font(.suite(type: .SUITE_Light, size: 19.5))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(height: 22)
                    
                    Spacer()
                    
                    Group {
                        if !viewModel.isStringEmpty {
                            Button {
                                viewModel.makeNickNameInputStringEmpty()
                            } label: {
                                xCircleImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(2.25)
                            }
                            .transition(.scale)
                        }
                    }                        
                    .animation(.easeIn, value: viewModel.isStringEmpty)
                    
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 14)
                }
                .frame(height: 24)
                
                Spacer()
                
                Rectangle()
                    .fill(viewModel.isNickNameInvalid ? .spotRed : .black)
                    .frame(height: 1)
            }
            .frame(height: 56)
            .padding(.top, 35)
            
            
            // Validation Text
            HStack {
                Group {
                    if viewModel.isNickNameInvalid {
                        Text("사용할 수 없는 닉네임 입니다.")
                            .foregroundStyle(.spotRed)
                    }
                    
                    if viewModel.isNickNameValid {
                        Text("멋진 닉네임이에요 :)")
                            .foregroundStyle(.black)
                    }
                }
                .font(.suite(type: .SUITE_Regular, size: 15))
                    
                
                Spacer()
            }
            .frame(height: 17)
            .padding(.top, 8)
            
            Spacer()
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        Rectangle()
            .fill(.red)
            .frame(height: 50)
        Rectangle()
            .fill(.orange)
            .frame(height: 28)
        Rectangle()
            .fill(.yellow)
            .frame(height: 42)
        NickNameInputView()
        Spacer()
    }
    .padding(.horizontal, 16)
}
