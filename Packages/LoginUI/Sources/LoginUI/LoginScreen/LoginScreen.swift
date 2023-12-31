//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/18.
//

import SwiftUI
import DefaultExtensions
import KakaoSDKAuth
import GlobalFonts

//TODO: Package에 외부 폰트 등록(otf파일이 문제인가?)


public struct LoginScreen: View {
    
    public init() { }
    
    var kakaoButtonImage: Image {
        let path = Bundle.module.provideFilePath(name: "kakao_button_image", ext: "png")
        return Image(uiImage: UIImage(named: path)!)
    }
    
    public var body: some View {
        VStack {
            
            Spacer()
            
            // 메인 텍스트
            HStack {
                VStack(alignment: .leading) {
                    Text("동네,")
                        .font(.suite(type: .SUITE_Regular, size: 50))
                    (
                    Text("일상을 ")
                        .font(.suite(type: .SUITE_Regular, size: 50))
                    +
                    Text("공유하다")
                        .font(.suite(type: .SUITE_SemiBold, size: 50))
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 48)
            .padding(.bottom, 36)
            
            
            // 스플래쉬 이미지
            // TODO: 완성된 이미지 삽입
            ZStack {
                Rectangle()
                    .fill(.gray)
                Text("일러스트 들어갈예정")
                    .font(.system(size: 30))
            }
                
            Spacer()
        
            kakaoButtonImage
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    KakaoLoginManager.shared.executeLogin()
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 27)
                .padding(.top, 48)
            
        }
    }
}

#Preview {
    LoginScreen()
}
