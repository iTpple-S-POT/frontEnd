//
//  Color+Extension.swift
//  
//
//  Created by 최준영 on 2023/11/22.
//

import SwiftUI

public extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var rgb: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
