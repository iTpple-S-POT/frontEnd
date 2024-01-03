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
import GlobalObjects
import UserInformationUI
import Alamofire

//TODO: Package에 외부 폰트 등록(otf파일이 문제인가?)


public struct LoginScreen: View {
    
    @EnvironmentObject private var mainNavigation: MainNavigation
    
    @State private var isKakaoLoginCompleted = false
    
    // Alert
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let serverErrorMessage = "서버가 불안정합니다."
    
    public init() { }
    
    var kakaoButtonImage: Image {
        let path = Bundle.module.provideFilePath(name: "kakao_button_image", ext: "png")
        return Image(uiImage: UIImage(named: path)!)
    }
    
    public var body: some View {
        NavigationView {
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
                        KakaoLoginManager.shared.executeLogin { result in
                            
                            switch result {
                            case .success(let tokens):
                                
                                APIRequestGlobalObject.shared.setToken(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken, isSaveInUserDefaults: true)
                                
                                // 토큰 발급 성공으로 인한 이동
                                // TODO: 선호도 입력 여뷰를 확인한 후 메인스크린으로 이동 구현
                                // 수정 예정
                                mainNavigation.addToStack(destination: .mainScreen)
                                
                            case .failure(let failure):
                                
                                // TODO: Error에 따른 로직, 추후 구현
                                showingAlert = true
                                
                                alertMessage = serverErrorMessage
                                
                            }
                            
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 27)
                    .padding(.top, 48)
                
            }
        }
        .alert("Server Error", isPresented: $showingAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }

    }
}

#Preview {
    LoginScreen()
}
