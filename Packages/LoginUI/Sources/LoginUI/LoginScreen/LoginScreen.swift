//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/18.
//

import SwiftUI
import DefaultExtensions
import KakaoSDKAuth

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
            
            VStack(alignment: .leading) {
                Text("동네,")
                (
                Text("일상을")
                +
                Text(" ")
                +
                Text("공유하다")
                )
            }
            
            Rectangle()
                .frame(height: 287)
                
            Spacer()
        
            kakaoButtonImage
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 16)
                .onTapGesture {
                    KakaoLoginManager.shared.executeLogin()
                }
            
        }
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
