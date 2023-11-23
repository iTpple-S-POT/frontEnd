//
//  InitialScreen.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalFonts
import GlobalUIComponents

public struct InitialScreen: View {
    
    @StateObject private var screenModel = InitialScreenModel()
    
    @State private var isBarActive = false
    
    @State private var initialViewOffset = CGSize.zero
    
    public init() { }
    
    var button1Text: String { screenModel.doesProfileSettingStart ? "다음" : "프로필 만들기" }
    
    var button2Text: String {
        screenModel.doesProfileSettingStart ? "다음에 하기" : "건너뛰기"
    }
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    public var body: some View {
        VStack(spacing: 0) {
            
            // View들이 등장할 공간
            GeometryReader { geo in
                ZStack {
                    InitialView()
                        .offset(initialViewOffset)
                    
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
                            
                            Group {
                                if isBarActive {
                                    let order = screenModel.settingPhaseIndex+1
                                    let countOfState = screenModel.settingPhaseCount
                                    MainScreenBarView(state: order, countOfState: countOfState)
                                        .padding(.top, 42)
                                        .padding(.bottom, 30)
                                        .transition(.opacity)
                                }
                            }
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
        
            
            // 버튼1
            SpotRoundedButton(text: button1Text, color: .spotRed) {
                
                if screenModel.doesProfileSettingStart {
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
            SpotTextButton(text: button2Text, color: .black) {
                //TODO: 디음에 하기
            }
            .padding(.top, 12)
        }
    }
}

/// 화면전환을 위한 매서드들
extension InitialScreen {
    
    /// 프로필 세팅을 시작하는 애니메이션
    func startProfileSetting() {
        
        let initialViewDisappearTime = 0.5
        let barAppearTime = 0.3
        
        withAnimation(.easeInOut(duration: initialViewDisappearTime)) {
            initialViewOffset = CGSize(width: -screenWidth, height: 0)
            let _ = screenModel.increateSettingPhaseIndex()
        }
        
        Timer.scheduledTimer(withTimeInterval: initialViewDisappearTime, repeats: false) { _ in
            withAnimation(.easeOut(duration: barAppearTime)) {
                isBarActive = true
            }
        }
    }
    
    /// 다음세팅 사항으로 화면을 넘긴다.
    func nextSetting() {
        
        let viewTransitionTime = 0.5
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            initialViewOffset = CGSize(width: -screenWidth, height: 0)
            let _ = screenModel.increateSettingPhaseIndex()
        }
    }
    
    /// 이전세팅 사항으로 돌아간다.
    func previousSetting() {
        let viewTransitionTime = 0.5
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            initialViewOffset = CGSize(width: -screenWidth, height: 0)
            let _ = screenModel.decreateSettingPhaseIndex()
        }
    }
    
}

#Preview {
    InitialScreen()
}
