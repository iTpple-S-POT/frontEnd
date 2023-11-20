//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/20.
//

import SwiftUI

internal protocol CustomFontProtocl: CaseIterable {
    static func registerFonts()
    var fontFileName: String { get }
    var fontFileExtension: String { get }
}

extension CustomFontProtocl {
    static func registerFonts() {
        Self.allCases.forEach {
            let fontName = $0.fontFileName
            let fontExtension = $0.fontFileExtension
            let fontUrl = URL(fileURLWithPath: Bundle.module.provideFilePath(name: fontName, ext: fontExtension))
            guard let fontProvider = CGDataProvider(url: fontUrl as CFURL), let cgFont = CGFont(fontProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(cgFont, &error)
        }
    }
}
