// The Swift Programming Language

import SwiftUI
import DefaultExtensions

public class SpotFontmanager {
    
    public static let shared = SpotFontmanager()
    
    private init() { }
    
    // 폰트가 등록되었음을 표시하는 프로퍼티
    public var fontIsRegistered = false
    
    // 폰트열거형 타입들
    private let fonts: [any CustomFontProtocl.Type] = [
        SUITE_Font.self,
    ]
    
    public func registerAllFonts() {
        fonts.forEach { $0.registerFonts() }
        fontIsRegistered = true
    }
}

