//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/20.
//

import SwiftUI

public extension Font {
    static func suite(type: SUITE_Font, size: CGFloat) -> Font {
        
        let manager = SpotFontmanager.shared
        
        if !manager.fontIsRegistered { manager.registerAllFonts() }
        
        return .custom(type.fontFileName, size: size)
    }
}

public extension UIFont {
    static func suite(type: SUITE_Font, size: CGFloat) -> UIFont {
        
        let manager = SpotFontmanager.shared
        
        if !manager.fontIsRegistered { manager.registerAllFonts() }
        
        guard let uiFont = UIFont(name: type.fontFileName, size: size) else {
            fatalError("\(type.fontFileName)으로 UIFont를 생성할 수 없습니다.")
        }
        
        return uiFont
    }
}
