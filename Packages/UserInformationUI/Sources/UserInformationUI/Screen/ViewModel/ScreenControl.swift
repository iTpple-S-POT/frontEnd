//
//  ScreenControl.swift
//
//
//  Created by 최준영 on 1/21/24.
//

import SwiftUI

extension ConfigurationScreenModel {
    
    /// 프로필 세팅을 시작하는 애니메이션
    func startProfileSetting() {
        
        let viewTransitionTime = 0.5
        
        withAnimation(.easeInOut(duration: viewTransitionTime)) {
            
            changeState(to: .setting)
               
        }
    }
    
    /// 다음세팅 사항으로 화면을 넘긴다.
    func nextSetting() {
        
        // 해당 메서드가 false를 반환한다는 것은 마지막 세팅 화면에서 버튼을 눌렀음을 의미한다.
        if !increateSettingPhaseIndex() {
            
            let viewTransitionTime = 0.5
            
            // 검증전 넘어가기 금지
            dontMoveOnToNext()
            
            withAnimation(.easeInOut(duration: viewTransitionTime))  {
             
                changeState(to: .final)
                
            }
        }
        
        // TODO: 최적화 문제로 애니메이션 제거
        
//        let viewTransitionTime = 0.5
//
//        withAnimation(.easeInOut(duration: viewTransitionTime)) {
//
//            // 해당 메서드가 false를 반환한다는 것은 마지막 세팅 화면에서 버튼을 눌렀음을 의미한다.
//            if !increateSettingPhaseIndex() {
//                changeState(to: .final)
//            }
//
//        }
    }
    
    /// 이전세팅 사항으로 돌아간다.
    func previousSetting() {
        
        let _ = decreateSettingPhaseIndex()
        
        // TODO: 최적화 문제로 애니메이션 제거
        
//        let viewTransitionTime = 0.5
//
//        withAnimation(.easeInOut(duration: viewTransitionTime)) {
//            let _ = decreateSettingPhaseIndex()
//        }
    }
    
    
    func button1Action() {
        
        switch screenState {
        case .final:
            print("데이터 전송")
        case .initial:
            startProfileSetting()
        case .setting:
            print("setting", canMoveOnToNext, settingPhaseIndex)
            
            let currentIndex = settingPhaseIndex
            let currentObject = settingScreenObjects[currentIndex]
            
            // 검증
            currentObject[keyPath: \.nextBtnValidation]()
            
            // 다음 세팅으로 넘어 갑니다.
            if canMoveOnToNext {
             nextSetting()
            }
        }
    }
}
