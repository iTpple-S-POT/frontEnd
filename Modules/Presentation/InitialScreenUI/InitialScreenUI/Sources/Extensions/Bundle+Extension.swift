//
//  Bundle+Extension.swift
//  InitialScreenUI
//
//  Created by 최준영 on 3/12/24.
//

import Foundation

extension Bundle {
    
    var apiURL: String {
        
        guard let filePath = self.path(forResource: "APIURL", ofType: "plist") else { fatalError() }
        
        guard let resource = NSDictionary(contentsOfFile: filePath) else { fatalError() }
        
        guard let apiUrl = resource["API_URL"] as? String else { fatalError("API URL를 설정해주세요") }
        
        if apiUrl == "API_URL을 입력해주세요" { fatalError("API URL를 설정해주세요") }
        
        return apiUrl
    }
}
