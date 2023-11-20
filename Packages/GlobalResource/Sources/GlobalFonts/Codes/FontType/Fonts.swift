//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/20.
//

import Foundation

public enum SUITE_Font: CustomFontProtocl {
    case SUITE_Bold, SUITE_ExtraBold, SUITE_Heavy, SUITE_Light, SUITE_Medium, SUITE_Regular, SUITE_SemiBold
    var fontFileName: String {
        var name = ""
        switch self {
        case .SUITE_Bold:
            name = "SUITE-Bold"
        case .SUITE_ExtraBold:
            name = "SUITE-ExtraBold"
        case .SUITE_Heavy:
            name = "SUITE-Heavy"
        case .SUITE_Light:
            name = "SUITE-Light"
        case .SUITE_Medium:
            name = "SUITE-Medium"
        case .SUITE_Regular:
            name = "SUITE-Regular"
        case .SUITE_SemiBold:
            name = "SUITE-SemiBold"
        }
        return name
    }
    var fontFileExtension: String { "otf" }
}
