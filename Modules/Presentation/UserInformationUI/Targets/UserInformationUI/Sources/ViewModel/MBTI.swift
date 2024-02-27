//
//  File.swift
//  
//
//  Created by 최준영 on 1/21/24.
//

import SwiftUI

enum UserMbtiPartCase: String, CaseIterable {
    case notDetermined = ""
    case E = "E",
         I = "I",
         S = "S",
         N = "N",
         T = "T",
         F = "F",
         J = "J",
         P = "P"
}

struct UserMbti: Equatable {
    var type1: UserMbtiPartCase = .notDetermined
    var type2: UserMbtiPartCase = .notDetermined
    var type3: UserMbtiPartCase = .notDetermined
    var type4: UserMbtiPartCase = .notDetermined
    
    mutating func setState(mbti: UserMbtiPartCase) {
        switch mbti {
        case .notDetermined:
            return
        case .E, .I:
            type1 = mbti
        case .S, .N:
            type2 = mbti
        case .T, .F:
            type3 = mbti
        case .J, .P:
            type4 = mbti
        }
    }
    
    func isStateMatch(mbti: UserMbtiPartCase) -> Bool {
        switch mbti {
        case .notDetermined:
            return false
        case .E, .I:
            return type1 == mbti
        case .S, .N:
            return type2 == mbti
        case .T, .F:
            return type3 == mbti
        case .J, .P:
            return type4 == mbti
        }
    }
    
    func getMBTIString() -> String? {
        
        let arr = [type1, type2, type3, type4]
        
        if arr.contains(.notDetermined) {
            return nil
        }
        
        let result = arr.reduce("") { partialResult, part in
            partialResult + part.rawValue
        }
        
        return result
    }
}
