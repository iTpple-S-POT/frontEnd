//
//  TagCases.swift
//  
//
//  Created by 최준영 on 1/24/24.
//

import SwiftUI
import DefaultExtensions

// 테그 색
extension ShapeStyle where Self == Color {
    
    static var tag_black: Color { Color.black }
    static var tag_red: Color { Color(hex: "FF533F") }
    static var tag_yellow: Color { Color(hex: "FFB800") }
    static var tag_green: Color { Color(hex: "86CC40") }
    static var tag_purple: Color { Color(hex: "D092ED") }
    static var tag_blue: Color { Color(hex: "5EA7FF") }
    
}

public typealias TagsDict = [TagCases: Bool]

/// 카테고리 정보와 혼용됩니다.
public enum TagCases: Int, Identifiable, CaseIterable {
    case all = 10
    case hot = 11
    case life = 1
    case information = 2
    case question = 3
    case party = 4
    
    public var id: Int { self.rawValue }
    
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
    
    public static subscript (_ id: Int64) -> TagCases {
        
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
