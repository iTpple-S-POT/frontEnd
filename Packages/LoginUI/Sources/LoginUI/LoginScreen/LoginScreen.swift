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
            
            HStack {
                VStack(alignment: .leading) {
                    Text("동네,")
                        .font(.suite(type: .SUITE_Light, size: 40))
                    (
                    Text("일상을 ")
                        .font(.suite(type: .SUITE_Light, size: 40))
                    +
                    Text("공유하다")
                        .font(.suite(type: .SUITE_SemiBold, size: 40))
                    )
                }
                Spacer()
            }
            
            Rectangle()
                .frame(height: 287)
                
            Spacer()
        
            kakaoButtonImage
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    KakaoLoginManager.shared.executeLogin()
                }
                .padding(.bottom, 40)
            
        }
        .padding(.horizontal, 16)
        .onOpenURL { url in
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

#Preview {
    LoginScreen()
}
