//
//  SpotProfileDetailView.swift
//
//
//  Created by 최준영 on 2/18/24.
//

import SwiftUI
import DefaultExtensions
import GlobalObjects

public struct SpotProfileDetailView: View {
    
    var userInfo: UserInfoObject
    
    private var profileData: [ProfileTuple] {
        [
            ProfileTuple(key: "생년월일", values: [
                {
                    guard let birthDay = userInfo.birthDay else { return "입력되지 않은 정보" }
                    
                    let splitedArr = birthDay.split(separator: "-")
                    
                    return "\(splitedArr[0])년 \(splitedArr[1])월 \(splitedArr[2])일"
                }()
            ]),
            ProfileTuple(key: "성별", values: [
                {
                    let gender = userInfo.gender
                    
                    return gender == "MALE" ? "남성" : "여성"
                }()
            ]),
            ProfileTuple(key: "MBTI", values: [userInfo.mbti ?? "입력되지 않은 정보"]),
            ProfileTuple(key: "취미와 관심사", values: userInfo.interests)
        ]
    }
    
    private var screenWidth: CGFloat {
        
        UIScreen.main.bounds.width
    }
    
    public init(userInfo: UserInfoObject) {
        self.userInfo = userInfo
    }
    
    public init(userInfo: SpotUser) {
        
        self.userInfo = UserInfoObject(
            id: userInfo.id,
            loginType: userInfo.loginType,
            role: userInfo.role,
            profileImageUrl: userInfo.profileImageUrl,
            name: userInfo.name,
            nickname: userInfo.nickName,
            phoneNumber: userInfo.phoneNumber,
            birthDay: userInfo.birthDay,
            gender: userInfo.gender,
            mbti: userInfo.mbti,
            interests: userInfo.interests?.components(separatedBy: ",") ?? [],
            status:userInfo.status
        )
    }
    
    public var body: some View {
        
        ZStack {
            
            Color.white
            
            ScrollView {
                
                VStack {
                    
                    ProfileShortCapView(
                        nickName: userInfo.nickname ?? "비지정 닉네임",
                        platformDescription: {
                            guard let loginType = userInfo.loginType else {
                                return ""
                            }
                            
                            switch loginType {
                            case "KAKAO":
                                return "카카오톡 회원"
                            case "APPLE":
                                return "애플회원"
                            default:
                                fatalError("처리되지 못한 플랫폼 형식")
                            }
                            
                        }()
                    )
                    
                    Rectangle()
                        .fill(.light_gray)
                        .frame(height: 8)
                        .padding(.top, 8)
                    
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 40) {
                            
                            ForEach(profileData, id: \.self) { element in
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text(element.key)
                                    
                                    if element.values.count >= 2 {
                                        
                                        ScrollView(.horizontal) {
                                            
                                            HStack(spacing: 12) {
                                                
                                                ForEach(element.values, id: \.self) {
                                                    
                                                    CircleTextView(text: $0)
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                    } else if !element.values.isEmpty {
                                        
                                        CircleTextView(text: element.values.first!)
                                    }
                                }
                            }
                        }
                        .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 21)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                }
            }
        }
    }
}

fileprivate struct ProfileTuple: Hashable {
   
    public init(key: String, values: [String]) {
        self.key = key
        self.values = values
    }
    
    var key: String
    var values: [String]
}

struct CircleTextView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 16))
            .foregroundStyle(.red)
            .frame(height: 40)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.red, lineWidth: 1)
            )
    }
}



#Preview {
    SpotProfileDetailView(
        userInfo: UserInfoObject(
            id: -1,
            loginType: "KAKAO",
            role: nil,
            profileImageUrl: "",
            name: "이름",
            nickname: "잇플잇플1",
            phoneNumber: "",
            birthDay: "2000-3-1",
            gender: "MALE",
            mbti: "ISFJ",
            interests: ["취미1", "취미2", "취미3"],
            status: "")
    )
}
