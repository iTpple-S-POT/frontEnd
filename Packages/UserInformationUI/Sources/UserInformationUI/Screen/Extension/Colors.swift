//
//  Colors.swift
//
//
//  Created by 최준영 on 2023/11/22.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    
    /// 뷰의 기본적인 바탕 색
    static var defaultBackgroundColor: Color { .white }
    
    /// TextFeild의 placeHolder Text에 사용되는 색상
    static var grayForText: Color { Color(hex: "6C6C6C") }
    
    /// MainScreen에 사용되는 '다음' 버튼의 색상
    static var spotRed: Color { Color(hex: "FF533F") }
    
    /// MainScreen에 움직이는 bar뒷 편의 바 색상입니다.
    static var spotLightGray: Color { Color(hex: "F5F4F4") }
}
