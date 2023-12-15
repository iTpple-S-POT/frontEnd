//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI


class InitialScreenModel: ObservableObject {
    
    @Published private(set) var screenState: InitialScreenState = .initial
    
    @Published private(set) var doesProfileSettingStart = false
    
    @Published var settingPhaseIndex: Int = 0
    @Published private(set) var settingPhases: [SettingPhase] = []
    
    var settingPhaseCount: Int { settingPhases.count }
    var getCurrentSettingPhase: SettingPhase {
        guard settingPhaseIndex >= 0 else { fatalError("setting단계가 아닌데 호출되었습니다.") }
        return settingPhases[settingPhaseIndex]
    }
    
    // 세팅 프로세스와 매칭되는 뷰
    let viewForProgressPhase: [SettingPhase : AnyView] = [
        .inputUserNickName : AnyView(NickNameInputView()),
        .selectUserSex : AnyView(SelectGenderScreenComponent()),
        .selectUserMBTI : AnyView(SelectMbtiScreenComponent()),
        .selectUserBirthDay : AnyView(SelectBirthDayView()),
        .selectUserInterests : AnyView(SelectInterestsView())
    ]
    
    init() {
        // 유저가 입력해야 하는 프로필 정보를 나타내는 리스트
        settingPhases = getUserSettingList()
    }
    
    /// 유저가 세팅해야할 유저정보를 반환하는 함수
    func getUserSettingList() -> [SettingPhase] {
        var result: [SettingPhase] = []
        
        //TODO: 요구사항에 맞춰 동적으로 조절
        result.append(.inputUserNickName)
        result.append(.selectUserSex)
        result.append(.selectUserMBTI)
        result.append(.selectUserBirthDay)
        result.append(.selectUserInterests)
        
        return result
    }
}

/// Setting Screen전환에 사용됩니다.
extension InitialScreenModel {
    
    /// Setting화면을 의미하는 타입입니다.
    enum SettingPhase {
        case inputUserNickName
        case selectUserSex
        case selectUserMBTI
        case selectUserBirthDay
        case selectUserInterests
    }
    
    /// settingPhaseIndex값을 증가시킨다. 더이상 증가할 수 없으면 false를 반환한다.
    func increateSettingPhaseIndex() -> Bool {
        if settingPhaseIndex+1 < settingPhaseCount {
            
            // 프로필 세팅이 식작됨을 알린다
            doesProfileSettingStart = true
            
            settingPhaseIndex += 1
            
            return true
        }
        return false
    }
    
    /// settingPhaseIndex값을 감소시킨다. 더이상 감소할 수 없으면 false를 반환한다.
    func decreateSettingPhaseIndex() -> Bool {
        if settingPhaseIndex > 0 {
            settingPhaseIndex -= 1
            return true
        }
        return false
    }
}

/// 스크린 상태전환에 사용됩니다.
extension InitialScreenModel {
    
    /// InitialScreen의 상태를 나타냅니다.
    enum InitialScreenState {
        case initial, setting, final
    }
    
    /// ScreenState를 설정합니다.
    func changeState(to: InitialScreenState) {
        self.screenState = to
    }
}
