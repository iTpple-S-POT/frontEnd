//
//  File.swift
//  
//
//  Created by 최준영 on 1/20/24.
//

import Foundation


extension ConfigurationScreenModel {
    
    enum UserGenderCase: String {
        case notDetermined = "notDetermined", male = "남성", female = "여성"
        
        func getSendForm() -> String? {
            switch self {
            case .notDetermined:
                return nil
            case .male:
                return "MALE"
            case .female:
                return "FEMALE"
            }
        }
    }
    
}


