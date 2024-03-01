//
//  InitialScreen.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalObjects
import GlobalFonts
import GlobalUIComponents

public struct UserInformationConfigurationScreen: View {
    
    @EnvironmentObject var mainNavigation: MainNavigation
    
    @StateObject private var screenModel = ConfigurationScreenModel()
    
    public init() { }
    
    var button1Text: String {
        
        var result = ""
        
        switch screenModel.screenState {
        case .initial:
            result = "프로필 만들기"
        case .setting:
            result = "다음"
        case .final:
            result = "시작하기"
        }
        
        return result
    }
    
    var button2Text: String { screenModel.screenState == .setting ? "건너뛰기" : "다음에 하기" }
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    public var body: some View {
        ZStack {
            
            ZStack {
                
                Group {
                    
                    if screenModel.screenState == .initial {
                        
                        StartConfigurationScreenComponent()
                        
                    }
                    
                    if screenModel.screenState == .final {
                        
                        FinishConfigurationScreenComponent()
                        
                    }
                    
                }
                
                Group {
                    
                    if screenModel.screenState == .setting {
                        
                        preferenceSettingScreenComponent
                        
                    }
                    
                }
                
            }
            
            mainButtons
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .alert(screenModel.alertTitle, isPresented: $screenModel.showAlert, actions: {
            Button("닫기") { }
        }, message: {
            Text(screenModel.alertContent)
        })
        .environmentObject(screenModel)
    }
}

/// 화면전환을 위한 매서드들
extension UserInformationConfigurationScreen {
    
    var mainButtons: some View {
        // 고정 버튼들
        VStack(spacing: 0) {
            
            Spacer(minLength: 0)
            
            // 버튼1
            SpotRoundedButton(text: button1Text, color: .spotRed) {    
                
                switch screenModel.screenState {
                case .initial:
                    screenModel.startProfileSetting()
                case .setting:
                    let currentIndex = screenModel.settingPhaseIndex
                    let currentObject = screenModel.settingScreenObjects[currentIndex]
                    
                    // 검증
                    currentObject[keyPath: \.nextBtnValidation]()
                    
                    // 다음 세팅으로 넘어 갑니다.
                    if screenModel.canMoveOnToNext {
                        screenModel.nextSetting()
                    }
                case .final:
                    Task {
                        do {
                            let object = try await screenModel.sendUserInfoToServer()
                            
                            try SpotStorage.default.mainStorageManager.updateUserInfo(newUserInfo: object)
                            
                            print("유저 초기정보 전송 성공")
                            
                            mainNavigation.addToStack(destination: .mainScreen)
                        } catch {
                            screenModel.showAlertWith(title: "에러", content: "잠시후 다시시도해주세요.")
                        }
                    }
                }
            }
            .padding(.horizontal, 21)
            .padding(.top, 48)
            
            // 버튼2
            ZStack {
                if (2..<5).contains(screenModel.settingPhaseIndex) {
                    SpotTextButton(text: button2Text, color: .black, action: screenModel.nextSetting)
                    .padding(.top, 12)
                }
            }
            .frame(height: 44)
        }
    }
}



// MARK: - User의 Preference를 설정하는 스크린 컴포넌트
extension UserInformationConfigurationScreen {
    
    var preferenceSettingScreenComponent: some View {
        GeometryReader { geo in
            
            VStack {
                // 상단 바
                ZStack {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 100)
                    
                    HStack {
                        if screenModel.settingPhaseIndex >= 1 {
                            Button(action: screenModel.previousSetting) {
                                ZStack {
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                }
                                .frame(width: 32, height: 32)
                            }
                            .buttonStyle(.spotDefault(backgroundColor: .clear))
                            Spacer()
                        }
                    }
                    .frame(height: 42)
                    .padding(.bottom, 58)
                    .padding(.horizontal, 4)
                    
                    let order = screenModel.settingPhaseIndex+1
                    let countOfState = screenModel.settingPhaseCount
                    
                    MainScreenBarView(state: order, countOfState: countOfState)
                        .padding(.top, 42)
                        .padding(.bottom, 30)
                        .transition(.opacity)
                }
                
                
                Spacer(minLength: 0)
                
                
                // 상단바 아래 뷰(세팅뷰들)
                ZStack {
                    ForEach((0..<5)) { index in
                        
                        let screenWidth = geo.size.width
                        let viewOffset = CGSize(width: screenWidth*CGFloat(index-screenModel.settingPhaseIndex), height: 0)
                        
                        screenModel.settingScreenObjects[index].screenComponent
                            .offset(viewOffset)
                    }
                }
                Spacer(minLength: 0)
                
            }
            .padding(.horizontal, 12)
        }
    }
}




#Preview {
    UserInformationConfigurationScreen()
        .environmentObject(MainNavigation())
}
