//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

enum SettingPhase {
    case inputUserNickName
    case selectUserSex
    case selectUserMBTI
    case selectUserBirthDay
    case selectUserInterests
}

class InitialScreenModel: ObservableObject {
    
    @Published private(set) var doesProfileSettingStart = false
    
    @Published var settingPhaseIndex: Int = -1
    @Published private(set) var settingPhases: [SettingPhase] = []
    
    var settingPhaseCount: Int { settingPhases.count }
    var getCurrentSettingPhase: SettingPhase {
        guard settingPhaseIndex >= 0 else { fatalError("setting단계가 아닌데 호출되었습니다.") }
        return settingPhases[settingPhaseIndex]
    }
    
    // 세팅 프로세스와 매칭되는 뷰
    let viewForProgressPhase: [SettingPhase : AnyView] = [
        .inputUserNickName : AnyView(NickNameInputView()),
        .selectUserSex : AnyView(Text("TODO1")),
        .selectUserMBTI : AnyView(Text("TODO2")),
        .selectUserBirthDay : AnyView(Text("TODO3")),
        .selectUserInterests : AnyView(Text("TODO4"))
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

