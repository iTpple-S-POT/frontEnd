//
//  SelectMapTagViewModel.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI

class SelectMapTagViewModel: ObservableObject {
    
    @Published private(set) var selectedTag: TagCases = .all
    @Published private(set) var selectedTagDict: [TagCases: Bool] = [
        .all : true,
        .hot : false,
        .life : false,
        .question : false,
        .information : false,
        .party : false
    ]
    
    // 현재활성화 되어있는 테그의 수를 추적합니다.
    private var activeTagCount: Int = 1
    
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

/// 카테고리 정보와 혼용됩니다.
public enum TagCases: Identifiable, CaseIterable {
    case all
    case hot
    case life
    case question
    case information
    case party
    
    public var id: Int { self.hashValue }
    
    public enum IconType { case idle, point }
    
    public func getIcon(type: IconType) -> Image {
        
        if self == .all {
            preconditionFailure("all태그는 이미지가 없습니다.")
        }
        
        var imageName = ""
        
        switch self {
        case .hot:
            imageName = "hot"
        case .life:
            imageName = "life"
        case .question:
            imageName = "question"
        case .information:
            imageName = "information"
        case .party:
            imageName = "party"
        default:
            preconditionFailure("처리되지 못한 테그")
        }
        
        imageName += "_\(type == .idle ? "idle" : "point")"
        
        return Image.makeImageFromBundle(bundle: Bundle.module, name: imageName, ext: .png)
    }
    
    public func getKorString() -> String {
        
        var textStr = ""
        
        switch self {
        case .all:
            textStr = "전체"
        case .hot:
            textStr = "인기"
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
    
    public func getPointColor() -> Color {
        
        switch self {
        case .all:
            return .tag_black
        case .hot:
            return .tag_red
        case .life:
            return .tag_yellow
        case .question:
            return .tag_green
        case .information:
            return .tag_purple
        case .party:
            return .tag_blue
        }
        
    }
    
    public func getIllust() -> Image {
        
        var imageName = ""
        
        switch self {
        case .life:
            imageName = "life"
        case .question:
            imageName = "question"
        case .information:
            imageName = "information"
        case .party:
            imageName = "party"
        default:
            preconditionFailure("처리되지 못한 테그")
        }
        
        imageName += "_illust"
        
        return Image.makeImageFromBundle(bundle: Bundle.module, name: imageName, ext: .png)
    }
    
    static subscript (_ id: Int64) -> TagCases {
        
        switch id {
        case 1:
            return .life
        case 2:
            return .information
        case 3:
            return .question
        case 4:
            return .party
        default:
            preconditionFailure("처리되지 못한 테그")
        }
        
    }
}
