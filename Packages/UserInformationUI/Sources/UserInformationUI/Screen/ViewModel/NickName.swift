//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

extension ConfigurationScreenModel {
    
    var isStringEmpty: Bool { nickNameInputString.isEmpty }
    
    /// 빈문자열이 아닌데 올바른 닉네임일 경우 true를 반환합니다.
    var isNickNameValid: Bool { !isStringEmpty && nickNameValidation() }
    
    /// 빈문자열이 아닌데 올바르지 않은 문자열인 경우 true를 반환합니다.
    var isNickNameInvalid: Bool { !isStringEmpty && !nickNameValidation() }
    
    /// 입력 문자열을 공백으로 만드는 매서드 입니다.
    func makeNickNameInputStringEmpty() { nickNameInputString = "" }
    
    func nickNameValidation() -> Bool {
        let nickName = nickNameInputString
        
        let regexString = "^[가-힣a-zA-Z0-9_]*$"
        
        // regexString이 올바른지 확인합니다.
        guard let regex = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive) else {
            fatalError("RegexString이 올바르지 않습니다.")
        }
        
        let range = NSRange(location: 0, length: nickName.utf16.count)
        
        return regex.firstMatch(in: nickName, range: range) != nil
    }
    
}
