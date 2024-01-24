//
//  File.swift
//  
//
//  Created by 최준영 on 1/24/24.
//

import SwiftUI

class MainScreenModel: ObservableObject {
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    // 맵태그 관련
    @Published var selectedTag: TagCases = .all
    @Published var selectedTagDict: [TagCases: Bool] = [
        .all : true,
        .hot : false,
        .life : false,
        .question : false,
        .information : false,
        .party : false
    ]
    // 현재활성화 되어있는 테그의 수를 추적합니다.
    var activeTagCount: Int = 1
    
    
    func showPotUploadSuccess() {
        
        showAlert = true
        alertTitle = "업로드 성공"
        alertMessage = "팟이 성공적으로 업로드됨"
    }
    
    func showPotUploadFailed() {
        
        showAlert = true
        alertTitle = "업로드 실패"
        alertMessage = "팟을 업로드하지 못했습니다."
    }
    
}
