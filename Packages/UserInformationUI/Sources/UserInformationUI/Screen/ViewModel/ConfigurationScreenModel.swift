//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalObjects

/// Setting화면을 의미하는 타입입니다.
enum SettingPhase: Hashable {
    case inputUserNickName
    case selectUserSex
    case selectUserMBTI
    case selectUserBirthDay
    case selectUserInterests
}

struct SettingScreenObject {

    var screenComponent: AnyView
    
    var phase: SettingPhase
    
    var nextBtnValidation: () -> Void
    
    init(view: AnyView, phase: SettingPhase, nextBtnValidation: @escaping () -> Void) {
        self.screenComponent = view
        self.nextBtnValidation = nextBtnValidation
        self.phase = phase
    }
    
}

extension SettingScreenObject: Equatable {
    
    static func == (lhs: SettingScreenObject, rhs: SettingScreenObject) -> Bool {
        lhs.phase == rhs.phase
    }
}


class ConfigurationScreenModel: ObservableObject {
    
    // Alert뷰
    @Published var showAlert = false
    var alertTitle = ""
    var alertContent = ""
    
    // 세팅 스크린 상태
    @Published private(set) var screenState: InitialScreenState = .initial
    @Published var settingPhaseIndex: Int = 0
    
    // '다음' 버튼 유효성
    @Published private(set) var canMoveOnToNext = false
    
    // 닉네임 입력
    @Published var nickNameInputString = ""
    
    // Interests
    @Published private(set) var userInterestMatrix: [[UserInterestType]] = []
    @Published var userInterestTypes: [UserInterestType:Bool] = [:]
    
    // Gender
    @Published var userGenderState: UserGenderCase = .notDetermined
    let genderCaseList: [UserGenderCase] = [ .male, .female ]
    
    // Birth day
    @Published var userBirthDay: Date = .now
    
    // MBTI
    @Published var userMBTI = UserMbti()
    

    var settingPhaseCount: Int { settingScreenObjects.count }
    
    var getCurrentSettingPhase: SettingPhase {
        guard settingPhaseIndex >= 0 else { fatalError("getCurrentSettingPhase 잘못된 호출") }
        return settingScreenObjects[settingPhaseIndex].phase
    }
    
    // 세팅 프로세스와 매칭되는 뷰
    lazy var settingScreenObjects: [SettingScreenObject] = [
        SettingScreenObject(view: AnyView(InputUserNickNameScreenComponent()), phase: .inputUserNickName) {
            
            if self.nickNameInputString.isEmpty {
                
                self.canMoveOnToNext = true
                
                return
            }
            
            if !self.isNickNameValid {
                
                self.showAlertWith(title: "닉네임 생성 불가", content: "잘못된 닉네임 형식 입니다.")
                
                return
            }
            
            Task {
                
                do {
                    
                    let validationResult = try await APIRequestGlobalObject.shared.checkIsNickNameAvailable(nickName: self.nickNameInputString)
                    
                    await MainActor.run {
                        
                        if validationResult.isSuccess {
                            
                            self.nextSetting()
                            
                        } else {
                            
                            self.showAlertWith(title: "닉네임 생성 불가", content: validationResult.reason)
                        }
                    }
                } catch {
                    print(error, error.localizedDescription)
                    
                    await MainActor.run {
                        self.showAlertWith(title: "오류", content: error.localizedDescription)
                    }
                }
            }
            
        },
        SettingScreenObject(view: AnyView(SelectBirthDayScreenComponent()), phase: .selectUserBirthDay) {
            
            self.canMoveOnToNext = true
        },
        SettingScreenObject(view: AnyView(SelectGenderScreenComponent()), phase: .selectUserSex) {
            
            self.canMoveOnToNext = true
        },
        SettingScreenObject(view: AnyView(SelectMbtiScreenComponent()), phase: .selectUserMBTI) {
            
            self.canMoveOnToNext = true
        },
        SettingScreenObject(view: AnyView(SelectInterestsScreenComponent()), phase: .selectUserInterests) {
            
            self.canMoveOnToNext = true
        },
    ]
    
    init() {
        // 선호도 메트릭스 생성
        self.userInterestMatrix = make2DArray()
        
        UserInterestType.allCases.forEach { type in
            userInterestTypes[type] = false
        }
    }
    
    func dontMoveOnToNext() {
        
        canMoveOnToNext = false
    }
    
}

/// Setting Screen전환에 사용됩니다.
extension ConfigurationScreenModel {
    
    /// settingPhaseIndex값을 증가시킨다. 더이상 증가할 수 없으면 false를 반환한다.
    func increateSettingPhaseIndex() -> Bool {
        
        settingPhaseIndex += 1
        
        if settingPhaseIndex < settingPhaseCount {
            
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
extension ConfigurationScreenModel {
    
    /// InitialScreen의 상태를 나타냅니다.
    enum InitialScreenState {
        case initial, setting, final
    }
    
    /// ScreenState를 설정합니다.
    func changeState(to: InitialScreenState) {
        self.screenState = to
    }
}

extension ConfigurationScreenModel {
    
    func showAlertWith(title: String, content: String) {
        
        self.alertTitle = title
        self.alertContent = content
        self.showAlert = true
    }
}



// MARK: - 데이타 트렌스퍼
extension ConfigurationScreenModel {
    
    func sendUserInfoToServer() async throws -> UserInfoObject {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthDayString = dateFormatter.string(from: userBirthDay)
        
        let filteredInterests = userInterestTypes.filter { (_, value) in value }
        
        let korInterests = filteredInterests.keys.map { $0.rawValue }
        
        let object = UserInfoObject(id: -1,
                                   loginType: nil,
                                   role: nil,
                                   profileImageUrl: nil,
                                   name: nil,
                                   nickname: nickNameInputString,
                                   phoneNumber: nil,
                                   birthDay: birthDayString,
                                   gender: userGenderState.getSendForm(),
                                   mbti: userMBTI.getMBTIString(),
                                   interests: korInterests,
                                   status: nil)
        
        try await APIRequestGlobalObject.shared.sendInitialUserInfomation(object: object)
        
        return object
    }
}
