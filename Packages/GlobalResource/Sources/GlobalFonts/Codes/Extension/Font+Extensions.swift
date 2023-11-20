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
