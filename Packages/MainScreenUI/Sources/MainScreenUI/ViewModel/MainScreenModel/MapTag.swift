//
//  MapTag.swift
//
//
//  Created by 최준영 on 1/24/24.
//

import SwiftUI
import GlobalObjects

extension MainScreenModel {

    func checkSelected(_ tag: TagCases) -> Bool { selectedTagDict[tag]! }
    
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

}
