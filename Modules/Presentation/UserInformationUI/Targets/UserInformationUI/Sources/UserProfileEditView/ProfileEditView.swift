//
//  ProfileEditView.swift
//  UserInformationUI
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

enum EditViewDestination {
    
    case root, nickName, mbti, date
}

enum EditViewError: Error {
    
    case editFailed
}

public struct ProfileEditView: View {
    
    var userInfo: SpotUser
    
    var completion: (Bool) -> Void
    
    public init(userInfo: SpotUser, completion: @escaping (Bool) -> Void) {
        self.userInfo = userInfo
        self.completion = completion
    }
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var configureModel = ConfigurationScreenModel()
    
    private var dateFormatter: DateFormatter {
        
        let df = DateFormatter()
        
        df.dateFormat = "yyyy-MM-dd"
        
        return df
    }
    
    private var dateString: String {
        
        let birthDay = dateFormatter.string(from: configureModel.userBirthDay)
        
        print(birthDay)
        
        let splitted = birthDay.split(separator: "-")
        
        return "\(splitted[0])년 \(splitted[1])월 \(splitted[2])일"
    }
    
    public var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white.ignoresSafeArea(.all, edges: .top)
                    .zIndex(0)
                
                EditViewNavBar(title: "프로필 수정") {
                    
                    dismiss()
                    
                } onComplete: {
                    
                    dismiss()
                    
                    Task {
                        
                        do {
                            
                            guard let mbtiString = configureModel.userMBTI.getMBTIString(), let genderString = configureModel.userGenderState.getSendForm() else {
                                
                                throw EditViewError.editFailed
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let birthDayString = dateFormatter.string(from: configureModel.userBirthDay)
                            
                            let filteredInterests = configureModel.userInterestTypes.filter { (_, value) in value }
                            
                            let korInterests = filteredInterests.keys.map { $0.rawValue }
                            
                            let object = UpdateUserDTO(
                                nickname: configureModel.nickNameInputString,
                                birthDay: birthDayString,
                                gender: genderString,
                                mbti: mbtiString,
                                interests: korInterests
                            )
                            
                            let newUserObject = try await APIRequestGlobalObject.shared.updateUserInfo(dto: object)
                            
                            try SpotStorage.default.mainStorageManager.updateUserInfo(newUserInfo: newUserObject)
                            
                            completion(true)
                            
                        } catch {
                            
                            completion(false)
                        }
                    }
                }
                .zIndex(2)
          
                GeometryReader { geo in
                    
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text("닉네임")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(height: 48)
                                .padding(.leading, 21)
                            
                            NavigationLink {
                                
                                NickNameEditView(configureModel: configureModel)
                                    .navigationBarBackButtonHidden()
                                
                            } label: {
                                
                                RowTextButtonLabel(title: configureModel.nickNameInputString)
                            }
                            
                            Rectangle()
                                .fill(.gray)
                                .frame(height: 1.0)
                                .padding(.horizontal, 21)
                            
                            Text("생년월일")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(height: 48)
                                .padding(.top, 30)
                                .padding(.leading, 21)
                            
                            NavigationLink {
                                
                                DateEditView(configureModel: configureModel)
                                    .navigationBarBackButtonHidden()
                                
                            } label: {
                                
                                RowTextButtonLabel(title: dateString)
                            }
                            .frame(height: 48)
                            .padding(.leading, 8)
                            
                            Rectangle()
                                .fill(.gray)
                                .frame(height: 1.0)
                                .padding(.horizontal, 21)
                            
                            Text("성별")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(height: 48)
                                .padding(.top, 30)
                                .padding(.leading, 21)
                            
                            HStack(spacing: 16.5) {
                                
                                ForEach(configureModel.genderCaseList, id: \.self) { element in
                                    GeometryReader { geo in
                                        
                                        let innerView = AnyView(Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 18)))
                                        
                                        SpotStateButton(innerView: innerView, idleColor: .spotLightGray, activeColor: .spotRed, frame: geo.size, radius: 20) {
                                            
                                            configureModel.userGenderState = element
                                        } activation: {
                                            
                                            configureModel.userGenderState == element
                                        }
                                    }
                                    .frame(height: 56)
                                }
                            }
                            .padding(.horizontal, 21)
                            
                            Text("MBTI")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(height: 48)
                                .padding(.top, 30)
                                .padding(.leading, 21)
                            
                            NavigationLink {
                                
                                MbtiSelectViewVer2(configureModel: configureModel)
                                    .navigationBarBackButtonHidden()
                                
                            } label: {
                                
                                RowTextButtonLabel(title: configureModel.userMBTI.getMBTIString() ?? "")
                            }
                            .frame(height: 48)
                            .padding(.leading, 8)
                                
                            
                            Rectangle()
                                .fill(.gray)
                                .frame(height: 1.0)
                                .padding(.horizontal, 21)
                            
                            Text("취미와 관심사")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.top, 30)
                                .padding(.leading, 21)
                            
                            Text("최소 2개 이상 골라주세요 :)")
                                .font(.system(size: 16))
                                .padding(.top, 5)
                                .padding(.leading, 21)
                            
                            VStack(alignment: .leading, spacing: 9) {
                                ForEach(configureModel.userInterestMatrix, id: \.self) { list1D in
                                    
                                    HStack(spacing: 9) {
                                        
                                        ForEach(list1D) { element in
                                            
                                            SpotStateButton(innerView: AnyView(Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 16))), idleColor: .spotLightGray, activeColor: .spotRed, frame: configureModel.getViewSize(string: element.rawValue), radius: 20) {
                                                
                                                if configureModel.isTypeExists(type: element) {
                                                    configureModel.deSelectType(type: element)
                                                    return
                                                }
                                                
                                                configureModel.selectType(type: element)
                                                
                                            } activation: {
                                                configureModel.isTypeExists(type: element)
                                            }

                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width-42)
                            .padding(.top, 10)
                            .padding(.horizontal, 21)
                        }
                    }
                    .frame(width: geo.size.width)
                    
                }
                .zIndex(1)
                .scrollIndicators(.hidden)
                .padding(.top, 56)
                
            }
        }
        .onAppear {
            
            projectUserInfo()
        }
    }
    
    func projectUserInfo() {
        
        // 닉네임
        if let nickName = userInfo.nickName {
            
            configureModel.nickNameInputString = nickName
        }
        
        // 생년월일
        if let birthDay = userInfo.birthDay {
            
            if let date = dateFormatter.date(from: birthDay) {
                
                configureModel.userBirthDay = date
            }
        }
        
        // 성별
        if let gender = userInfo.gender, let genderType = UserGenderCase.getTypeFromString(str: gender) {
            
            configureModel.userGenderState = genderType
        }
        
        // MBTI
        if let mbti = userInfo.mbti {
            
            let mbtiArr = mbti.split(separator: "")
            
            configureModel.userMBTI.type1 = UserMbtiPartCase(rawValue: String(mbtiArr[0])) == .E ? .E : .I
            
            configureModel.userMBTI.type2 = UserMbtiPartCase(rawValue: String(mbtiArr[1])) == .S ? .S : .N
            
            configureModel.userMBTI.type3 = UserMbtiPartCase(rawValue: String(mbtiArr[2])) == .T ? .T : .F
            
            configureModel.userMBTI.type4 = UserMbtiPartCase(rawValue: String(mbtiArr[3])) == .J ? .J : .P
        }
        
        // 관심사
        userInfo.interests?.split(separator: ",").forEach { interest in
            
            if let type = UserInterestType(rawValue: String(interest)) {
                
                configureModel.userInterestTypes[type] = true
            }
        }
    }
}
