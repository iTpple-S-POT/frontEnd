//
//  SelectMapTagViewModel.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI

class SelectMapTagViewModel: ObservableObject {
    
    @Published private(set) var selectedTag: TagCases?
    @Published private(set) var selectedTagDict: [TagCases:Bool] = [
        .all : true,
        .event : false,
        .life : false,
        .question : false,
        .information : false,
        .party : false
    ]
    
    // 현재활성화 되어있는 테그의 수를 추적합니다.
    private var activeTagCount: Int = 1
    
    func selectTag(tag: TagCases) {
        
        selectedTag = tag
        
        switch tag {
        case .all:
            // 모든 버튼들을 inactive상태로 변경
            selectedTagDict.keys.forEach { selectedTagDict[$0] = false }
            
            selectedTagDict[.all] = true
            
            activeTagCount = 1
        default:
            // all테그를 inactive상태로 지정
            if selectedTagDict[.all]! {
                selectedTagDict[.all] = false
                activeTagCount -= 1
            }
            
            if selectedTagDict[tag]! {
                
                activeTagCount -= 1
                
                selectedTagDict[tag] = false
                
                // 활성화 되어있는 테그가 없는 경우 '모두 보기'로 설정된다
                if activeTagCount < 1 {
                    
                    selectedTagDict[.all] = true
                    
                    activeTagCount = 1
                    
                }
                
                
            } else {
                
                activeTagCount += 1
                
                selectedTagDict[tag] = true
                
            }
            
        }
        
    }
    
    func clearSelectedTag() {
        selectedTag = nil
    }
    
}

extension SelectMapTagViewModel {
    
    enum TagCases: String, Identifiable, CaseIterable {
        case all = "all"
        case event = "event"
        case life = "life"
        case question = "question"
        case information = "information"
        case party = "party"
        
        var id: String { self.rawValue }
        
        func getIconImage() -> Image {
            
            if self == .all {
                preconditionFailure("all태그는 이미지가 없습니다.")
            }
            
            let imageName = self.rawValue + "_tag"
            
            return Image.makeImageFromBundle(bundle: Bundle.module, name: imageName, ext: .png)
        }
        
        func getTextString() -> String {
            
            var textStr = ""
            
            switch self {
            case .all:
                textStr = "모두 보기"
            case .event:
                textStr = "사건/사고"
            case .life:
                textStr = "일상"
            case .question:
                textStr = "질문"
            case .information:
                textStr = "정보"
            case .party:
                textStr = "모임"
            }
            
            return textStr
        }
    }

    
}
