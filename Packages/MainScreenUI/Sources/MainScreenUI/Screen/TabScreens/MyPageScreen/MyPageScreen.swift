//
//  MyPageScreen.swift
//
//
//  Created by 최준영 on 2/18/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

struct MyPageScreen: View {
    @FetchRequest(sortDescriptors: [])
    private var currentUserInfo: FetchedResults<SpotUser>
    
    private var userInfo: SpotUser { currentUserInfo.first! }
    

    @State private var showProfileDetail = false
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            ScrollView {
                
                VStack(spacing: 0) {
                    
                    HStack {
                        
                        Text("마이페이지")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Spacer()
                        
                        Button {
                             
                            // TODO: 설정
                            
                        } label: {
                            Image.makeImageFromBundle(bundle: .module, name: "gear_icon", ext: .png)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28)
                        }
                        
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 21)
                    
                    ProfileShortCapView(
                        nickName: userInfo.nickName ?? "비지정 닉네임",
                        platformDescription: {
                            guard let loginType = userInfo.loginType else {
                                return "처리되지 못한 플랫폼"
                            }
                            
                            switch loginType {
                            case "Kakao":
                                return "카카오톡 회원"
                            case "Apple":
                                return "애플회원"
                            default:
                                fatalError("처리되지 못한 플랫폼 형식")
                            }
                            
                        }()
                    )
                    
                    // 내프로필 보기
                    Button {
                        
                        withAnimation {
                            showProfileDetail = true
                        }
                        
                    } label: {
                        
                        Text("내 프로필 보기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(height: 40)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.light_gray)
                            )
                    }
                    
                    // TODO: 최근 본 팟
                        
                    Spacer()
                    
                }
            }
            
            if showProfileDetail {
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        Color.white
                        
                        Text("내 프로필")
                            .font(.system(size: 20, weight: .semibold))
                        
                        HStack {
                            
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        showProfileDetail = false
                                    }
                                }
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, 21)
                        
                    }
                    .frame(height: 56)
                    
                    SpotProfileDetailView(userInfo: userInfo)
                }
                .transition(.move(edge: .trailing))
            }
            
        }
    }
}

//#Preview {
//    MyPageScreen(userInfo: UserInfoObject(
//        id: -1,
//        loginType: "KAKAO",
//        role: nil,
//        profileImageUrl: "",
//        name: "이름",
//        nickname: "잇플잇플1",
//        phoneNumber: "",
//        birthDay: "2000-3-1",
//        gender: "MALE",
//        mbti: "ISFJ",
//        interests: ["취미1", "취미2", "취미3"],
//        status: nil)
//    )
//}
