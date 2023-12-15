//
//  InitialScreen.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalFonts
import GlobalUIComponents

public struct UserInformationConfigurationScreen: View {
    
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
            
            // View들이 등장할 공간
            GeometryReader { geo in
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
                            // 세팅 뷰 
                            VStack {
                                // 상단 바
                                ZStack {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: 100)
                                    
                                    HStack {
                                        if screenModel.settingPhaseIndex >= 1 {
                                            Button(action: previousSetting) {
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
                                    ForEach(Array(screenModel.settingPhases.enumerated()), id: \.element) { index, element in
                                        
                                        let screenWidth = geo.size.width
                                        let viewOffset = CGSize(width: screenWidth*CGFloat(index-screenModel.settingPhaseIndex), height: 0)
                                        
                                        screenModel.viewForProgressPhase[element]
                                            .offset(viewOffset)
                                    }
                                }
                                Spacer(minLength: 0)
                                
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                }
            }
            
            // 고정 버튼들
            VStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                // 버튼1
                SpotRoundedButton(text: button1Text, color: .spotRed) {
                    
                    if screenModel.screenState == .setting {
                        let currentPhase = screenModel.getCurrentSettingPhase
                        
                        //TODO: 입력 데이터를 저장
                        switch currentPhase {
                        case .inputUserNickName:
                            break
                        default:
                            break
                        }
                        
                        // 다음 세팅으로 넘어 갑니다.
                        nextSetting()
                    } else {
                        startProfileSetting()
                    }
                    
                }
                .padding(.horizontal, 12)
                .padding(.top, 48)
                
                // 버튼2
                ZStack {
                    Group {
                        if screenModel.screenState != .final {
                            SpotTextButton(text: button2Text, color: .black) {
                                //TODO: 디음에 하기
                            }
                            .padding(.top, 12)
                        }
                    }
                }
                .frame(height: 44)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

/// 화면전환을 위한 매서드들
extension UserInformationConfigurationScreen {
    
    /// 프로필 세팅을 시작하는 애니메이션
    func startProfileSetting() {
        
        let viewTransitionTime = 0.5
        
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            
            screenModel.changeState(to: .setting)
               
        }
    }
    
    /// 다음세팅 사항으로 화면을 넘긴다.
    func nextSetting() {
        
        let viewTransitionTime = 0.5
        
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            
            // 해당 메서드가 false를 반환한다는 것은 마지막 세팅 화면에서 버튼을 눌렀음을 의미한다.
            if !screenModel.increateSettingPhaseIndex() {
                screenModel.changeState(to: .final)
            }
            
        }
    }
    
    /// 이전세팅 사항으로 돌아간다.
    func previousSetting() {
        
        let viewTransitionTime = 0.5
        
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            let _ = screenModel.decreateSettingPhaseIndex()
        }
    }
    
}

#Preview {
    UserInformationConfigurationScreen()
}
