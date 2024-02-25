//
//  MyPageScreen.swift
//
//
//  Created by 최준영 on 2/18/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

class MyPageScreenModel: ObservableObject {
    
    @Published private(set) var recentlyViewedPotModels: [PotModel] = []
    
    init() {
        
        NotificationCenter.potSelection.addObserver(self, selector: #selector(refreshRecentlyViewedPot(_:)), name: .singlePotSelection, object: nil)
        
        Task {
            await getRecentlyViewedPots()
        }
    }
    
    @objc
    func refreshRecentlyViewedPot(_ notification: Notification) {
        
        Task {
            await getRecentlyViewedPots()
        }
    }
    
    func getRecentlyViewedPots() async {
        
        do {
            
            let potObjects = try await APIRequestGlobalObject.shared.getRecentlyViewedPot()
            
            let models = potObjects.map { PotModel.makePotModelFrom(potObject: $0) }
            
            DispatchQueue.main.async {
                self.recentlyViewedPotModels = models
            }
            
        } catch {
            
            print("최근 본 팟 불러오기 실패")
        }
    }
}


struct MyPageScreen: View {
    @FetchRequest(sortDescriptors: [])
    private var currentUserInfo: FetchedResults<SpotUser>
    
    private var userInfo: SpotUser { currentUserInfo.first! }
    
    @StateObject private var screenModel = MyPageScreenModel()

    @State private var showProfileDetail = false
    
    var itemSize: CGSize {
        
        CGSize(width: 120, height: 160)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.white.ignoresSafeArea(.all, edges: .top)
                
                VStack {
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
                    .background(
                        Rectangle().fill(.white)
                            .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
                    )
                    
                    Spacer()
                }
                .zIndex(1.0)
                
                ScrollView {
                    
                    VStack(spacing: 0) {
                        
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
                        NavigationLink {
                            
                            ProfileDetailView(userInfo: userInfo)
                                .navigationBarBackButtonHidden()
                            
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
                        
                        Rectangle()
                            .fill(.light_gray)
                            .frame(height: 8)
                            .padding(.vertical, 30)
                        
                        // 최근본 팟
                        HStack {
                            
                            Text("최근 본 POT")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 21)
                        
                        
                        ScrollView(.horizontal) {
                            
                            LazyHStack(spacing: 12) {
                                
                                Spacer(minLength: 9)
                                    .frame(width: 9)
                                
                                
                                ForEach(screenModel.recentlyViewedPotModels, id: \.id) { model in
                                    
                                    PotListCell(potModel: model, itemSize: itemSize)
                                        .frame(
                                            width: itemSize.width,
                                            height: itemSize.height
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            .frame(height: itemSize.height)
                            .padding(.top, 8)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .padding(.top, 56)
                .zIndex(0.0)
            }
        }
    }
}

fileprivate struct ProfileDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var userInfo: SpotUser
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
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
                                dismiss()
                            }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 21)
                    
                }
                .frame(height: 56)
                .background(
                    Rectangle().fill(.white)
                        .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
                )
                
                Spacer()
            }
            .zIndex(1.0)
            
            VStack(spacing: 0) {
                
                SpotProfileDetailView(userInfo: userInfo)
                    .padding(.top, 56)
                
                Spacer()
            }
            .zIndex(0.0)
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
